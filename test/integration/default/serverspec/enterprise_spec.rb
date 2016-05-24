require 'spec_helper'

describe group('mule') do
  it { should exist }
  it { should have_gid 4000 }
end

describe user('mule') do
  it { should exist }
  it { should have_uid 4000 }
  it { should belong_to_group 'mule' }
end

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

describe file('/usr/local/mule-esb/conf/wrapper.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'mule' }
  it { should be_grouped_into 'mule' }
end

describe service('mule-esb') do
  it { should be_enabled }
  it { should be_running }
end
