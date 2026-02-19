# frozen_string_literal: true

module Api
  module V1
    class SurveysController < BaseController
      before_action :set_survey, only: %i[show update destroy]

      def index
        @surveys = Survey.active.order(created_at: :desc)
      end

      def show
      end

      def create
        @survey = Survey.new(survey_params)
        unless @survey.save
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless @survey.update(survey_params)
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @survey.soft_delete
        head :no_content
      end

      private

      def set_survey
        @survey = Survey.includes(:survey_questions).find_by!(uuid: params[:id])
      end

      def survey_params
        params.require(:survey).permit(:name, :description)
      end
    end
  end
end