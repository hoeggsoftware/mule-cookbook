require 'mule_helper'

RSpec.describe Mule.Helper, do
  context 'given a correct username, password, organization, and environment' do
    USERNAME = 'testusername'
    PASSWORD = 'testpassword'
    ORGANIZATION = 'testorg'
    ENVIRONMENT = 'testenv'
    AUTH_TOKEN = 'aa12345a-b123-1c2d-23ee-1234ff123gg4'
    ORG_ID = 'aaa12345-ab89-1234-cdef-08989cd0909e'
    ENV_ID = 'aabc1234a-bc56-de7f-12ab-123abc456def'
    REG_TOKEN = 'aa12345a-b123-1c2d-23ee-1234ff123gg4---12345'
    PROFILE = '{"id": "ab3333ab-ab12-12ba-2222-9001aabb9001","createdAt": "2016-06-09T21:46:47.217Z","updatedAt": "2016-06-15T14:57:30.823Z","firstName": "testusername","lastName": "testusername","email": "testusername@example.com","phoneNumber": "111 111 1111","idprovider_id": "mulesoft","username": "testusername","enabled": true,"deleted": false,"organizationPreferences": {},"organization": {"name": "testorg","id": "aaa12345-ab89-1234-cdef-08989cd0909e","createdAt": "2016-06-09T21:46:47.244Z","updatedAt": "2016-06-09T21:46:47.283Z","ownerId": "ab3333ab-ab12-12ba-2222-9001aabb9001","clientId": "3081587907bf463e825d207c4f8cd77f","domain": "testorg","idprovider_id": "mulesoft","isFederated": false,"parentOrganizationIds": [],"subOrganizationIds": [],"tenantOrganizationIds": [],"isMaster": true,"subscription": {"type": "Free","expiration": "2016-07-09T21:46:47.241Z"},"properties": {},"environments": [{"id": "abc1234a-bc56-de7f-12ab-123abc456def","name": "testenv","organizationId": "aaa12345-ab89-1234-cdef-08989cd0909e","isProduction": false}],"entitlements": {"createEnvironments": true,"partnersSandbox": {"assigned": 0},"globalDeployment": false,"createSubOrgs": false,"hybrid": {"enabled": true},"vCoresProduction": {"assigned": 1,"reassigned": 0},"vCoresSandbox": {"assigned": 0,"reassigned": 0},"staticIps": {"assigned": 0,"reassigned": 0},"workerLoggingOverride": {"enabled": false},"mqMessages": {"base": 0,"addOn": 0},"mqRequests": {"base": 0,"addOn": 0},"gateways": {"assigned": 0},"partnersProduction": {"assigned": 0},"loadBalancer": {"assigned": 0},"externalIdentity": true,"autoscaling": false,"armAlerts": false,"apis": {"enabled": true},"messaging": {"assigned": 0}},"owner": {"id": "ab3333ab-ab12-12ba-2222-9001aabb9001","username": "testusername","firstName": "testusername","lastName": "testusername","email": "testusername@example.com","organizationId": "aaa12345-ab89-1234-cdef-08989cd0909e","enabled": true,"idprovider_id": "mulesoft","createdAt": "2016-06-09T21:46:47.217Z","updatedAt": "2016-06-15T14:57:30.823Z"}},"properties": {},"memberOfOrganizations": [{"name": "testorg","id": "aaa12345-ab89-1234-cdef-08989cd0909e","createdAt": "2016-06-09T21:46:47.244Z","updatedAt": "2016-06-09T21:46:47.283Z","ownerId": "ab3333ab-ab12-12ba-2222-9001aabb9001","clientId": "3081587907bf463e825d207c4f8cd77f","domain": "testorg","idprovider_id": "mulesoft","isFederated": false,"parentOrganizationIds": [],"subOrganizationIds": [],"tenantOrganizationIds": [],"parentName": null,"parentId": null,"isMaster": true,"subscription": {"type": "Free","expiration": "2016-07-09T21:46:47.241Z"}}],"contributorOfOrganizations": [{"name": "testorg","id": "aaa12345-ab89-1234-cdef-08989cd0909e","createdAt": "2016-06-09T21:46:47.244Z", "updatedAt": "2016-06-09T21:46:47.283Z","ownerId": "ab3333ab-ab12-12ba-2222-9001aabb9001","clientId": "3081587907bf463e825d207c4f8cd77f","domain": "testorg","idprovider_id": "mulesoft","isFederated": false,"parentOrganizationIds": [],"subOrganizationIds": [],"tenantOrganizationIds": [],"parentName": null,"parentId": null,"isMaster": true,"subscription": {"type": "Free","expiration": "2016-07-09T21:46:47.241Z"}}],"access_token": "aa12345a-b123-1c2d-23ee-1234ff123gg4","permissions": {"cloudhub": {"view": true},"api_platform": {"view": true},"exchange": {"view": true},"messaging": {"view": false},"dgw": {"view": false},"admin": {"view": false},"support": {"view": true},"partners": {"view": false},"access_manager": {"view": true}}}'

    it 'gets an authorization token' do
      authToken = get_auth_token(USERNAME, PASSWORD)
      expect(authToken).to eq AUTH_TOKEN
    end
    it 'gets a profile' do
      profile = get_profile(AUTH_TOKEN)
      expect(profile).to eq PROFILE
    end
    it 'gets an organization id' do
      orgId = get_org_id(PROFILE, ORGANIZATION)
      expect(orgId).to eq ORG_ID
    end

    it 'gets an environment id' do
      envId = get_org_id(PROFILE, ORGANIZATION, ENVIRONMENT)
      expect(envId).to eq ENV_ID
    end

    it 'gets a registration token' do
      regToken = get_arm_token(AUTH_TOKEN, ORG_ID, ENV_ID)
      expect(regToken).to eq REG_TOKEN
    end
  end
end
