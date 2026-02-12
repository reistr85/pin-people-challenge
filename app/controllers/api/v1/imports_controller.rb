# frozen_string_literal: true

module Api
  module V1
    class ImportsController < ApplicationController
      def create
        path = nil
        unless params[:file].respond_to?(:tempfile)
          return render json: { error: "Nenhum arquivo enviado" }, status: :unprocessable_entity
        end

        file = params[:file].tempfile
        unless File.extname(params[:file].original_filename).downcase == ".csv"
          return render json: { error: "Arquivo deve ser .csv" }, status: :unprocessable_entity
        end

        dir = Rails.root.join("storage", "imports")
        FileUtils.mkdir_p(dir)
        path = dir.join("#{SecureRandom.uuid}.csv")
        FileUtils.cp(file.path, path)

        job = CsvImportJob.perform_later(path.to_s, params[:client_id].presence)
        render json: {
          job_id: job.job_id,
          status: "queued",
          message: "Importação enfileirada. O CSV será processado em background."
        }, status: :accepted
      rescue StandardError => e
        File.delete(path) if path && File.exist?(path)
        Rails.logger.error("[ImportsController] #{e.message}")
        render json: { error: "Falha ao enfileirar importação" }, status: :internal_server_error
      end
    end
  end
end
