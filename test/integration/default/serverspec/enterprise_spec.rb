require 'spec_helper'

describe group('mule') do
    it { should exist }
end

describe user('mule') do
    it { should exist }
    it { should belong_to_group 'mule' }
end

describe service('mule-esb') do
    it { should be_enabled }
    it { should be_running }
end

describe service('mule-esb-2') do
    it { should be_enabled }
    it { should be_running }
end

if os[:family] == 'ubuntu'
    describe file('/etc/init/mule-esb.conf') do
        it { should exist }
        it { should be_file }
    end

    describe file('/etc/default/mule-esb') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
    end

    describe file('/usr/local/mule-esb-test/conf/wrapper.conf') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-Djava.net.preferIPv4Stack=TRUE' }
        it { should contain '-Dmvel2.disable.jit=TRUE' }
        it { should contain '-XX:+HeapDumpOnOutOfMemoryError' }
        it { should contain '-XX:+AlwaysPreTouch' }
        it { should contain '-XX:+UseParNewGC' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=' }
        it { should contain '-XX:PermSize=' }
        it { should contain '-XX:MaxPermSize=' }
        it { should contain '-XX:NewSize=' }
        it { should contain '-XX:MaxNewSize=' }
        it { should contain '-XX:MaxTenuringThreshold=' }
    end

    describe file('/etc/init/mule-esb-2.conf') do
        it { should exist }
        it { should be_file }
    end

    describe file('/etc/default/mule-esb-2') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
    end

    describe file('/usr/local/mule-esb-test-2/conf/wrapper.conf') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-Djava.net.preferIPv4Stack=TRUE' }
        it { should contain '-Dmvel2.disable.jit=TRUE' }
        it { should contain '-XX:+HeapDumpOnOutOfMemoryError' }
        it { should contain '-XX:+AlwaysPreTouch' }
        it { should contain '-XX:+UseParNewGC' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=' }
        it { should contain '-XX:PermSize=' }
        it { should contain '-XX:MaxPermSize=' }
        it { should contain '-XX:NewSize=' }
        it { should contain '-XX:MaxNewSize=' }
        it { should contain '-XX:MaxTenuringThreshold=' }
    end
elsif os[:family] == 'windows'
    describe file('c:\\Program Files\\Mule\\mule-esb-test\\bin\\mule.bat') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-M-DMULE_ENV=test'}
        it { should contain '-M-Dspring.profiles.active=test'}
    end

    describe file('c:\\Program Files\\Mule\\mule-esb-test\\conf\\wrapper.conf') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-Djava.net.preferIPv4Stack=TRUE' }
        it { should contain '-Dmvel2.disable.jit=TRUE' }
        it { should contain '-XX:+HeapDumpOnOutOfMemoryError' }
        it { should contain '-XX:+AlwaysPreTouch' }
        it { should contain '-XX:+UseParNewGC' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=' }
        it { should contain '-XX:PermSize=' }
        it { should contain '-XX:MaxPermSize=' }
        it { should contain '-XX:NewSize=' }
        it { should contain '-XX:MaxNewSize=' }
        it { should contain '-XX:MaxTenuringThreshold=' }
    end

    describe file('c:\\Program Files\\Mule\\mule-esb-test-2\\bin\\mule.bat') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-M-DMULE_ENV=test'}
        it { should contain '-M-Dspring.profiles.active=test'}
    end

    describe file('c:\\Program Files\\Mule\\mule-esb-test-2\\bin\\wrapper.conf') do
        it { should exist }
        it { should be_file }
        it { should be_owned_by 'mule' }
        it { should be_grouped_into 'mule' }
        it { should contain '-Djava.net.preferIPv4Stack=TRUE' }
        it { should contain '-Dmvel2.disable.jit=TRUE' }
        it { should contain '-XX:+HeapDumpOnOutOfMemoryError' }
        it { should contain '-XX:+AlwaysPreTouch' }
        it { should contain '-XX:+UseParNewGC' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=' }
        it { should contain '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=' }
        it { should contain '-XX:PermSize=' }
        it { should contain '-XX:MaxPermSize=' }
        it { should contain '-XX:NewSize=' }
        it { should contain '-XX:MaxNewSize=' }
        it { should contain '-XX:MaxTenuringThreshold=' }
    end
end
