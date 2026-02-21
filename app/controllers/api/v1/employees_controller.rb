# frozen_string_literal: true

module Api
  module V1
    class EmployeesController < BaseController
      before_action :set_employee, only: %i[show update destroy]
      before_action :authorize_employees_index!, only: [:index]
      before_action :authorize_employees_create!, only: [:create]
      before_action :authorize_employees_destroy!, only: [:destroy]

      def index
        scope = employees_scope.active
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
        if params[:client_uuid].present? && current_user.admin?
          client = Client.find_by(uuid: params[:client_uuid])
          scope = scope.where(client_id: client.id) if client
        elsif current_user.client? && current_client
          scope = scope.where(client_id: current_client.id)
        end

        @employees = scope.page(params[:page]).per(params[:per_page].presence || 25)
      end

      def show
      end

      def create
        @employee = Employee.new(employee_params)
        assign_client_by_uuid!
        unless @employee.save
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        assign_client_by_uuid!
        unless @employee.update(employee_params)
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.soft_delete
        head :no_content
      end

      private

      def authorize_employees_index!
        return if current_user.admin?
        return if current_user.client? && current_client
        return if current_user.collaborator? && current_employee
        forbid!
      end

      def authorize_employees_create!
        return if current_user.admin?
        return if current_user.client? && current_client
        forbid!
      end

      def authorize_employees_destroy!
        return if current_user.admin?
        return if current_user.client? && current_client && employees_scope.exists?(@employee&.id)
        forbid!
      end

      def employees_scope
        if current_user.admin?
          Employee.all
        elsif current_user.client? && current_client
          Employee.where(client_id: current_client.id)
        elsif current_user.collaborator? && current_employee
          Employee.where(id: current_employee.id)
        else
          Employee.none
        end
      end

      def set_employee
        @employee = Employee.includes(:client, :job_title, :departament, :role).merge(employees_scope).find_by!(uuid: params[:id])
      end

      def employee_params
        list = %i[name personal_email corporation_email uf city tenure gender]
        list << :user_id if current_user.admin?
        params.require(:employee).permit(list)
      end

      def assign_client_by_uuid!
        return unless params[:employee].present?
        if current_user.admin? && params[:employee][:client_uuid].present?
          client = Client.find_by(uuid: params[:employee][:client_uuid])
          @employee.client = client if client
        elsif current_user.client? && current_client
          @employee.client = current_client
        end
      end
    end
  end
end