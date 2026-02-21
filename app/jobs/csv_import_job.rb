# frozen_string_literal: true

require "csv"

class CsvImportJob < ApplicationJob
  queue_as :default

  # Colunas do CSV: nome da pergunta (score) => nome do comentário
  QUESTION_COLUMNS = {
    "Interesse no Cargo" => "Comentários - Interesse no Cargo",
    "Contribuição" => "Comentários - Contribuição",
    "Aprendizado e Desenvolvimento" => "Comentários - Aprendizado e Desenvolvimento",
    "Feedback" => "Comentários - Feedback",
    "Interação com Gestor" => "Comentários - Interação com Gestor",
    "Clareza sobre Possibilidades de Carreira" => "Comentários - Clareza sobre Possibilidades de Carreira",
    "Expectativa de Permanência" => "Comentários - Expectativa de Permanência",
    "eNPS" => "[Aberta] eNPS"
  }.freeze

  # Chamada com S3: perform(bucket, key, client_id)
  # Chamada com arquivo local: perform(file_path, client_id)
  def perform(arg1, arg2, arg3 = nil)
    if arg3.present?
      s3_bucket = arg1
      s3_key = arg2
      client_id = arg3
      csv_content = S3ImportUploader.download(s3_bucket, s3_key)
      process_csv_content(csv_content, client_id)
    else
      file_path = arg1
      client_id = arg2
      return unless File.exist?(file_path)
      process_csv_file(file_path, client_id)
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  def process_csv_file(file_path, client_id)
    client = resolve_client(client_id)
    survey = find_or_create_survey!(client)
    ensure_survey_questions!(survey)

    imported = 0
    errors_count = 0
    CSV.foreach(file_path, headers: true, col_sep: ";", encoding: "UTF-8") do |row|
      import_row(row, client, survey)
      imported += 1
    rescue StandardError => e
      errors_count += 1
      Rails.logger.warn("[CsvImportJob] Linha #{imported + errors_count + 1}: #{e.message}")
    end
    Rails.logger.info("[CsvImportJob] Importação concluída: #{imported} linhas, #{errors_count} erros")
  end

  def process_csv_content(csv_content, client_id)
    client = resolve_client(client_id)
    survey = find_or_create_survey!(client)
    ensure_survey_questions!(survey)

    imported = 0
    errors_count = 0
    CSV.parse(csv_content, headers: true, col_sep: ";", encoding: "UTF-8") do |row|
      import_row(row, client, survey)
      imported += 1
    rescue StandardError => e
      errors_count += 1
      Rails.logger.warn("[CsvImportJob] Linha #{imported + errors_count + 1}: #{e.message}")
    end
    Rails.logger.info("[CsvImportJob] Importação concluída (S3): #{imported} linhas, #{errors_count} erros")
  end

  def resolve_client(client_id)
    client = client_id.present? ? Client.find_by(id: client_id) : nil
    client ||= Client.find_or_create_by!(name: "Cliente Importação") do |c|
      c.email = "importacao@cliente.local"
    end
    client
  end

  def find_or_create_survey!(client)
    Survey.find_or_create_by!(name: "Pesquisa de Clima") do |s|
      s.client_id = client.id
      s.description = "Importação via CSV"
    end
  end

  private

  def ensure_survey_questions!(survey)
    QUESTION_COLUMNS.each_key do |label|
      survey.survey_questions.find_or_create_by!(question: label)
    end
  end

  def import_row(row, client, survey)
    job_title = find_or_create_job_title(row["cargo"])
    departament = find_or_create_departament(row["area"])
    role = find_or_create_role(row["funcao"])

    employee = Employee.find_or_initialize_by(corporation_email: row["email_corporativo"]&.strip.to_s)
    employee.assign_attributes(
      name: row["nome"]&.strip,
      personal_email: row["email"]&.strip,
      client_id: client.id,
      job_title_id: job_title&.id,
      departament_id: departament&.id,
      role_id: role&.id,
      city: row["localidade"]&.strip,
      tenure: row["tempo_de_empresa"]&.strip,
      gender: row["genero"]&.strip
    )
    employee.save!

    QUESTION_COLUMNS.each do |question_label, comment_label|
      question = survey.survey_questions.find_by!(question: question_label)
      value = parse_score(row[question_label])
      comment = row[comment_label]&.strip.presence

      response = SurveyQuestionResponse.find_or_initialize_by(
        survey_question_id: question.id,
        employee_id: employee.id
      )
      response.value = value
      response.comment = comment
      response.save!
    end
  end

  def find_or_create_job_title(name)
    return nil if name.blank?
    JobTitle.find_or_create_by!(name: name.strip)
  end

  def find_or_create_departament(name)
    return nil if name.blank?
    Departament.find_or_create_by!(name: name.strip)
  end

  def find_or_create_role(name)
    return nil if name.blank?
    Role.find_or_create_by!(name: name.strip)
  end

  def parse_score(value)
    return nil if value.blank? || value.to_s.strip == "-"
    value.to_s.strip.to_i
  end
end
