require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.before(:each) do
    stub_request(:get, /https:\/\/anypoint\.mulesoft\.com\/.\/login/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'Content-Type'=>'application/json'}).
      to_return(status: 200, body: "stubbed response", headers: {})
  end
  config.before(:each) do
    stub_request(:get, /https:\/\/anypoint\.mulesoft\.com\/accounts\/api\/profile/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'Authorization'=>'bearer aa12345a-b123-1c2d-23ee-1234ff123gg4'}).
      to_return(status: 200, body: "stubbed response", headers: {})
  end
  config.before(:each) do
    stub_request(:get, /https:\/\/anypoint\.mulesoft\.com\/hybrid\/api\/v1\/servers\/registrationToken/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'Authorization'=>'bearer aa12345a-b123-1c2d-23ee-1234ff123gg4',
          'X-ANYPNT-ORG-ID'=>'aaa12345-ab89-1234-cdef-08989cd0909e','X-ANYPNT-ENV-ID'=>'abc1234a-bc56-de7f-12ab-123abc456def'}).
      to_return(status: 200, body: "stubbed response", headers: {})
  end
end
