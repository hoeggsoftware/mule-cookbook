require 'mule_helper'

RSpec.describe Mule.Helper, do
  context 'given a correct username, password, organization, and environment' do
    it 'gets an authorization token' do
      orgId
      expect(orgId).to eq 'aa12345a-b123-1c2d-23ee-1234ff123gg4'
    end
      it 'gets an organization id' do
        orgId
        expect(orgId).to eq 'aaa12345-ab89-1234-cdef-08989cd0909e'
      end
    it 'gets an environment id' do
        envId
      expect(envId).to eq 'abc1234a-bc56-de7f-12ab-123abc456def'
    end
    it 'gets a registration token' do
      regToken
      expect(regToken).to eq 'f1cfbc8b-de53-4450-93df-05d6c15adf00'
    end
  end
end
