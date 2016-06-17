describe Mule::Helper do
  let(:helper) { Class.new { include Mule::Helper}}
  let(:username) {'testusername'}
  let(:password) {'testpassword'}
  let(:organization) {'testorg'}
  let(:environment) {'testenv'}
  let(:authToken) {'aa12345a-b123-1c2d-23ee-1234ff123gg4'}
  let(:orgId) {'aaa12345-ab89-1234-cdef-08989cd0909e'}
  let(:envId) {'abc1234a-bc56-de7f-12ab-123abc456def'}
  let(:regToken) {'aa12345a-b123-1c2d-23ee-1234ff123gg4---12345'}
  describe '.get_auth_token' do
    it 'gets an authorization token' do
      expect(helper.new.get_auth_token(username, password)).to eq authToken
    end
  end
  describe '.get_org_id' do
    it 'gets an organization id' do
      expect(helper.new.get_org_id(authToken, organization)).to eq orgId
    end
  end
  describe '.get_env_id' do
    it 'gets an environment id' do
      expect(helper.new.get_env_id(authToken, orgId, environment)).to eq envId
    end
  end
  describe '.get_arm_token' do
    it 'gets a registration token' do
      expect(helper.new.get_arm_token(authToken, orgId, envId)).to eq regToken
    end
  end
end
