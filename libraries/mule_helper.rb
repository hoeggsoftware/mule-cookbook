require 'rest-client'

module Mule
  module Helper
    def amc_setup(username, password, organization, environment)
      registrationToken = ''
    end

    def get_auth_token(username, password)
      response = RestClient.post('https://anypoint.mulesoft.com/accounts/login',
        { 'username' => username, 'password' => password }.to_json, 'Content-Type' => 'application/json')
      authToken = JSON.parse(response.body).values_at('access_token')[0]
    end
    def get_org_id(auth, organization)
      response = RestClient.get('https://anypoint.mulesoft.com/accounts/api/profile',
        'Authorization' => 'bearer ' + auth)
      orgList = JSON.parse(response.body).values_at('memberOfOrganizations')[0]
      orgId = ''
      orgList.each do |org|
        testOrg = org.values_at('name')[0]
        if testOrg.eql?(organization)
          orgId = org.values_at('id')[0]
        end
      end
      orgId
    end
    def get_env_id(auth, orgId, environment)
      response = RestClient.get('https://anypoint.mulesoft.com/accounts/api/organizations/' + orgId,
        'Authorization' => 'bearer ' + auth)
      envList = JSON.parse(response.body).values_at('environments')[0]
      envId = ''
      envList.each do |env|
        testEnv = env.values_at('name')[0]
        if testEnv.eql?(environment)
          envId = env.values_at('id')[0]
        end
      end
      envId
    end
    def get_arm_token(auth, orgId, envId)
      response = RestClient.get('https://anypoint.mulesoft.com/hybrid/api/v1/servers/registrationToken',
        'Authorization' => 'bearer ' + auth, 'X-ANYPNT-ORG-ID' => orgId, 'X-ANYPNT-ENV-ID'=> envId)
      regToken = JSON.parse(response.body).values_at('data')[0]
    end
  end
end
