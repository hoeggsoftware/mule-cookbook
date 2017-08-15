describe group('mule') do
  it { should exist }
end

describe user('mule') do
  it { should exist }
  its('groups') { should include('mule') }
end

describe file('/usr/local/mule-esb-test/conf/wrapper.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'mule' }
  it { should be_grouped_into 'mule' }
  its('content') { should include('-Djava.net.preferIPv4Stack=TRUE') }
  its('content') { should include('-Dmvel2.disable.jit=TRUE') }
  its('content') { should include('-XX:+HeapDumpOnOutOfMemoryError') }
  its('content') { should include('-XX:+AlwaysPreTouch') }
  its('content') { should include('-XX:+UseParNewGC') }
  its('content') { should include('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=') }
  its('content') { should include('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=') }
  its('content') { should include('-XX:PermSize=') }
  its('content') { should include('-XX:MaxPermSize=') }
  its('content') { should include('-XX:NewSize=') }
  its('content') { should include('-XX:MaxNewSize=') }
  its('content') { should include('-XX:MaxTenuringThreshold=') }
end

describe service('mule-esb') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/usr/local/mule-esb-test-2/conf/wrapper.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'mule' }
  it { should be_grouped_into 'mule' }
  its('content') { should include('-Djava.net.preferIPv4Stack=TRUE') }
  its('content') { should include('-Dmvel2.disable.jit=TRUE') }
  its('content') { should include('-XX:+HeapDumpOnOutOfMemoryError') }
  its('content') { should include('-XX:+AlwaysPreTouch') }
  its('content') { should include('-XX:+UseParNewGC') }
  its('content') { should include('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=') }
  its('content') { should include('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=') }
  its('content') { should include('-XX:PermSize=') }
  its('content') { should include('-XX:MaxPermSize=') }
  its('content') { should include('-XX:NewSize=') }
  its('content') { should include('-XX:MaxNewSize=') }
  its('content') { should include('-XX:MaxTenuringThreshold=') }
end

describe service('mule-esb-2') do
  it { should be_enabled }
  it { should be_running }
end
