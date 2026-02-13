# frozen_string_literal: true

json.partial! "api/v1/surveys/survey", survey: survey

json.survey_questions survey.survey_questions.active do |sq|
  json.partial! "api/v1/surveys/survey_question", survey_question: sq
end
