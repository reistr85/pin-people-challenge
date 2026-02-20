# frozen_string_literal: true

module Api
  module V1
    class EmployeesController < BaseController
      before_action :set_employee, only: %i[show update destroy]

      def index
        scope = Employee.active
          .includes(:client, :job_title, :departament, :role)
          .order(created_at: :desc)

        scope = scope.where("LOWER(name) LIKE LOWER(?)", "%#{params[:name].to_s.strip}%") if params[:name].present?
        if params[:email].present?
          term = "%#{params[:email].to_s.strip}%"
          scope = scope.where(
            "LOWER(personal_email) LIKE LOWER(?) OR LOWER(corporation_email) LIKE LOWER(?)",
            term, term
          )
        end

        @employees = scope.page(params[:page]).per(params[:per_page].presence || 25)
      end

      def show
      end

      def create
        @employee = Employee.new(employee_params)
        assign_associations_by_uuid!
        unless @employee.save
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless @employee.update(employee_params)
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.soft_delete
        head :no_content
      end

      private

      def set_employee
        @employee = Employee.includes(:client, :job_title, :departament, :role).find_by!(uuid: params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :name, :personal_email, :corporation_email, :uf, :city, :tenure, :gender
        )
      end
    end
  end
end