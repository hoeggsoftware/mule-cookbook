require 'net/http'
module Mule
  module Helper
    def amc_setup(username, password, organization, environment)
      registrationToken
    end

    def get_auth_token(username, password)
      authToken
    end
    def get_profile(auth)
      profile
    end
    def get_org_id(profile, organization)
      orgId
    end
    def get_env_id(profile, organization, environment)
      envId
    end
    def get_arm_token(auth, orgId, envId)
  end
end
