# frozen_string_literal: true

json.array! @surveys, partial: "api/v1/surveys/survey", as: :survey
