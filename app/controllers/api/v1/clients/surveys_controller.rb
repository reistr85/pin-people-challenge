# frozen_string_literal: true

module Api
  module V1
    module Clients
      class SurveysController < ApplicationController
        include ApiJsonWithoutId

        before_action :set_client
        before_action :set_survey, only: %i[show update destroy]

        def index
          surveys = @client.surveys.active.order(created_at: :desc)
          render json: api_json(surveys)
        end

        def show
          render json: api_json(@survey)
        end

        def create
          survey = @client.surveys.new(survey_params)
          if survey.save
            render json: api_json(survey), status: :created
          else
            render json: { errors: survey.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @survey.update(survey_params)
            render json: api_json(@survey)
          else
            render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @survey.soft_delete
          head :no_content
        end

        private

        def set_client
          @client = Client.find_by!(uuid: params[:client_uuid])
        end

        def set_survey
          @survey = @client.surveys.find_by!(uuid: params[:uuid])
        end

        def survey_params
          params.require(:survey).permit(:name, :description)
        end
      end
    end
  end
end