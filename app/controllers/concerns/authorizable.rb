# frozen_string_literal: true

module Authorizable
  extend ActiveSupport::Concern

  def current_client
    return nil unless current_user&.client?
    @current_client ||= current_user.client
  end

  def current_employee
    return nil unless current_user&.collaborator?
    @current_employee ||= current_user.employee
  end

  def forbid!(message = "Acesso negado")
    render json: { error: message }, status: :forbidden
  end

  def authorize_admin!
    return if current_user&.admin?
    forbid!
  end

  def authorize_client_or_admin!
    return if current_user&.admin?
    return if current_user&.client? && current_client.present?
    forbid!
  end

  def authorize_collaborator_or_above!
    return if current_user&.admin?
    return if current_user&.client?
    return if current_user&.collaborator? && current_employee.present?
    forbid!
  end
end
