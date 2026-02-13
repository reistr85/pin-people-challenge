# frozen_string_literal: true

json.uuid employee.uuid
json.name employee.name
json.personal_email employee.personal_email
json.corporation_email employee.corporation_email
json.uf employee.uf
json.city employee.city
json.tenure employee.tenure
json.gender employee.gender
json.client_uuid employee.client&.uuid
json.job_title_uuid employee.job_title&.uuid
json.departament_uuid employee.departament&.uuid
json.role_uuid employee.role&.uuid
json.created_at employee.created_at
json.updated_at employee.updated_at
json.deleted_at employee.deleted_at
