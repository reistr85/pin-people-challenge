# frozen_string_literal: true

json.array! @clients, partial: "api/v1/clients/client", as: :client
