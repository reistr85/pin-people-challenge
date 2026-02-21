# frozen_string_literal: true

require Rails.root.join("app/services/database_cleaner_service.rb").to_s

module Api
  module V1
    class ImportsController < BaseController
      before_action :authorize_import!

      def create
        path = nil
        unless params[:file].respond_to?(:tempfile)
          return render json: { error: "Nenhum arquivo enviado" }, status: :unprocessable_entity
        end

        file = params[:file].tempfile
        unless File.extname(params[:file].original_filename).downcase == ".csv"
          return render json: { error: "Arquivo deve ser .csv" }, status: :unprocessable_entity
        end

        if ActiveModel::Type::Boolean.new.cast(params[:clear_database])
          ::DatabaseCleanerService.clear_all!
        end

        dir = Rails.root.join("storage", "imports")
        FileUtils.mkdir_p(dir)
        path = dir.join("#{SecureRandom.uuid}.csv")
        FileUtils.cp(file.path, path)

        client_id = resolved_import_client_id

        # S3 só é usado quando S3_IMPORT_BUCKET está definido; senão usa storage local
        if use_s3?
          s3_info = S3ImportUploader.upload(path.to_s)
          File.delete(path) if File.exist?(path)
          path = nil
          job = CsvImportJob.perform_later(s3_info[:bucket], s3_info[:key], client_id)
        else
          job = CsvImportJob.perform_later(path.to_s, client_id)
        end

        job_id = job.respond_to?(:job_id) ? job.job_id : job.try(:jid)
        render json: {
          job_id: job_id,
          status: "queued",
          message: "Importação enfileirada. O CSV será processado em background."
        }, status: :accepted
      rescue StandardError => e
        File.delete(path) if path && File.exist?(path)
        Rails.logger.error("[ImportsController] #{e.class}: #{e.message}")
        Rails.logger.error(e.backtrace&.first(10)&.join("\n"))
        error_message = Rails.env.development? || Rails.env.test? ? "#{e.class}: #{e.message}" : "Falha ao enfileirar importação"
        render json: { error: error_message }, status: :internal_server_error
      end

      private

      def authorize_import!
        return if current_user.admin?
        return if current_user.client? && current_client
        forbid!
      end

      def use_s3?
        ENV["S3_IMPORT_BUCKET"].present?
      end

      def resolved_import_client_id
        if current_user.admin?
          if params[:client_uuid].present?
            c = Client.find_by(uuid: params[:client_uuid])
            c&.id&.to_s
          else
            params[:client_id].presence
          end
        elsif current_user.client? && current_client
          current_client.id.to_s
        else
          nil
        end
      end
    end
  end
end
