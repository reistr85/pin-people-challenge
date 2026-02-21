# frozen_string_literal: true

module Api
  module V1
    class SurveysController < BaseController
      before_action :set_survey, only: %i[show update destroy responses]
      before_action :authorize_surveys_write!, only: %i[create update destroy]
      before_action :authorize_responses!, only: %i[responses]

      def index
        @surveys = surveys_scope.active.includes(:client).order(created_at: :desc)
      end

      def show
        set_survey_question_responses!
      end

      def create
        @survey = Survey.new(survey_params)
        assign_client_by_uuid!
        if @survey.save
          create_or_update_questions!
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        assign_client_by_uuid!
        if @survey.update(survey_params)
          create_or_update_questions!
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @survey.soft_delete
        head :no_content
      end

      def responses
        return render json: { errors: ["Nenhuma resposta enviada"] }, status: :unprocessable_entity unless params[:responses].is_a?(Array)
        errors = []
        params[:responses].each do |resp_params|
          q = @survey.survey_questions.active.find_by(uuid: resp_params[:survey_question_uuid])
          next unless q
          record = current_employee.survey_question_responses.find_or_initialize_by(survey_question_id: q.id)
          record.value = resp_params[:value].nil? || resp_params[:value] == "" ? nil : resp_params[:value].to_i
          record.comment = resp_params[:comment].presence
          unless record.save
            errors.concat(record.errors.full_messages)
          end
        end
        if errors.any?
          render json: { errors: errors }, status: :unprocessable_entity
        else
          set_survey_question_responses!
          render :show
        end
      end

      private

      def authorize_surveys_write!
        return if current_user.admin?
        return if current_user.client? && current_client
        forbid! # collaborator: only read
      end

      def authorize_responses!
        return if current_user.collaborator? && current_employee && @survey.client_id == current_employee.client_id
        forbid!
      end

      def surveys_scope
        if current_user.admin?
          Survey.all
        elsif current_user.client? && current_client
          Survey.where(client_id: current_client.id)
        elsif current_user.collaborator? && current_employee&.client_id.present?
          Survey.where(client_id: current_employee.client_id)
        else
          Survey.none
        end
      end

      def set_survey
        @survey = Survey.includes(:client, :survey_questions).merge(surveys_scope).find_by!(uuid: params[:id])
      end

      def set_survey_question_responses!
        return unless current_user.collaborator? && current_employee
        question_ids = @survey.survey_questions.active.pluck(:id)
        @survey_question_responses = current_employee.survey_question_responses
          .where(survey_question_id: question_ids)
          .includes(:survey_question)
          .map do |r|
            {
              survey_question_uuid: r.survey_question.uuid,
              value: r.value,
              comment: r.comment.presence
            }
          end
      end

      def survey_params
        params.require(:survey).permit(:name, :description)
      end

      def assign_client_by_uuid!
        if current_user.admin? && params.dig(:survey, :client_uuid).present?
          client = Client.find_by(uuid: params[:survey][:client_uuid])
          @survey.client = client if client
        elsif current_user.client? && current_client
          @survey.client = current_client
        end
      end

      def create_or_update_questions!
        return unless params[:survey][:survey_questions_attributes]

        params[:survey][:survey_questions_attributes].each do |question_params|
          if question_params[:_destroy] == '1' || question_params[:_destroy] == true
            if question_params[:uuid].present?
              question = @survey.survey_questions.find_by(uuid: question_params[:uuid])
              question&.soft_delete
            end
          elsif question_params[:uuid].present?
            question = @survey.survey_questions.find_by(uuid: question_params[:uuid])
            if question
              question.update(question: question_params[:question])
            else
              @survey.survey_questions.create(question: question_params[:question])
            end
          else
            @survey.survey_questions.create(question: question_params[:question])
          end
        end
      end
    end
  end
end