# frozen_string_literal: true

module ApiJsonWithoutId
  extend ActiveSupport::Concern

  # Serializa um ou vários registros para JSON dos endpoints, sem o campo id.
  def api_json(record_or_collection)
    if record_or_collection.respond_to?(:to_ary)
      record_or_collection.map { |r| r.as_json.except("id") }
    else
      record_or_collection.as_json.except("id")
    end
  end
end