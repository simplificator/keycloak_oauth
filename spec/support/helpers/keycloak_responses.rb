module Helpers
  module KeycloakResponses
    def keycloak_tokens_request_body
      "{\"access_token\":\"#{access_token}\"," \
      "\"expires_in\":32765,\"refresh_expires_in\":1800,\"refresh_token\":\"" \
      "#{refresh_token}\",\"token_type\":\"bearer\",\"not-before-policy\":0," \
      "\"session_state\":\"e4567259-6c07-4dd1-800b-d01692ed2634\",\"scope\":\"" \
      "profile email\"}"
    end

    def access_token
      "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJNMjhQwMTY5MmVkMjYzNCIsIm" \
      "FjciI6IjAiLCJhbGxvd2VkLW9yaWdpbnMiOlsiIl0sInJlYWxtX2FjYZXNvdXJjZV9hY2Nlc3Mi" \
      "Onsid2ViZ2F0ZSI6eyJyb2xlcyI6WyJzdXBlcmFkbWluIl19LCJY"
    end

    def refresh_token
      "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhNDk0NzcxOS01NWU5LTQzYTg" \
      "tYTU0NS1kOWQzMzAzNjEzMWEifQ.eyJqdGkiOiJmNGFkODcyZC1mZTRlLTQ1ZGMtOWFjOC0yODg1OW"
    end

    def keycloak_invalid_code_request_error_body
      "{\"error\":\"invalid_grant\",\"error_description\":\"Code not valid\"}"
    end
  end
end