# frozen_string_literal: true

json.data do
  json.array! @employees, partial: "api/v1/employees/employee", as: :employee
end

json.meta do
  json.current_page @employees.current_page
  json.total_pages @employees.total_pages
  json.total_count @employees.total_count
  json.per_page @employees.limit_value
end
