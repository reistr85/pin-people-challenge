ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

module ApiTestHelpers
  def api_auth_headers(user)
    token = user.is_a?(User) ? user.auth_token : user
    { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
  end
end
