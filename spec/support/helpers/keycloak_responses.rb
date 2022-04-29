module Helpers
  module KeycloakResponses
    def keycloak_authorization_code_body
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

    def keycloak_user_info_request_body
      "{\"sub\":\"62647491-07ba-4961-8b9a-38e43916b4a0\",\"email_verified\":true" \
      ",\"name\":\"First User\",\"groups\":[\"/group_A\"],\"preferred_username" \
      "\":\"first_user\",\"given_name\":\"First\",\"family_name\":\"User\",\"" \
      "email\":\"first_user@example.com\"}"
    end

    def keycloak_invalid_code_request_error_body
      "{\"error\":\"invalid_grant\",\"error_description\":\"Code not valid\"}"
    end

    def keycloak_invalid_token_request_error_body
      "{\"error\":\"invalid_token\",\"error_description\":\"Token invalid: Failed to parse JWT\"}"
    end

    def keycloak_invalid_refresh_token_error_body
      "{\"error\":\"invalid_grant\",\"error_description\":\"Invalid refresh token\"}"
    end

    def keycloak_users_request_body
      "[{\"id\":\"fd62fb4e-04e1-4660-a961-f4592b95bb45\",\"createdTimestamp\":1606123457175" \
      ",\"username\":\"user_A\",\"enabled\":true,\"totp\":false,\"" \
      "emailVerified\":false,\"firstName\":\"User A First Name\",\"lastName\":" \
      "\"User A Last Name\",\"email\":\"user_A@example.com\",\"disableableCredentialTypes\":[]" \
      ",\"requiredActions\":[],\"notBefore\":0,\"access\":{\"manageGroupMembership\":true" \
      ",\"view\":true,\"mapRoles\":true,\"impersonate\":false,\"manage\":true}}]"
    end

    def keycloak_refresh_token_request_body
      "{\"access_token\":\"#{access_token}\",\"expires_in\":60,\"refresh_expires_in\":1800,\"" \
      "refresh_token\":\"#{refresh_token}\",\"token_type\":\"Bearer\",\"not-before-policy\":0,\"" \
      "session_state\":\"e4567259-6c07-4dd1-800b-d01692ed2634\",\"scope\":\"email profile\"}"
    end
  end
end
