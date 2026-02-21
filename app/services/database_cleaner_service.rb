# frozen_string_literal: true

class DatabaseCleanerService
  # Remove todos os dados de negócio (mantém apenas Users).
  # Ordem respeitando FKs: respostas -> perguntas -> enquetes -> colaboradores -> clientes -> cargos/áreas/funções
  def self.clear_all!
    ActiveRecord::Base.transaction do
      SurveyQuestionResponse.unscoped.delete_all
      SurveyQuestion.unscoped.delete_all
      Survey.unscoped.delete_all
      Employee.unscoped.delete_all
      Client.unscoped.delete_all
      JobTitle.unscoped.delete_all
      Departament.unscoped.delete_all
      Role.unscoped.delete_all
    end
  end
end
