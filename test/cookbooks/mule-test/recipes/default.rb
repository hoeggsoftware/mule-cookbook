directory '/tmp/mule'

if node['mule-test']['enterprise']
  aws_s3_file '/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip' do
      bucket 'hoegg-ci-data'
      remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
      aws_access_key node['aws']['access_key']
      aws_secret_access_key node['aws']['secret']
      not_if do ::File.exists?('/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip') end
  end
else
  remote_file "/tmp/mule/mule-standalone-3.8.0.zip" do
    source 'https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.8.0/mule-standalone-3.8.0.zip'
    action :create
  end
end

group node['mule-test']['group'] do
end

user node['mule-test']['user'] do
    manage_home true
    shell '/bin/bash'
    home "/home/#{node['mule-test']['user']}"
    comment 'Mule user'
    group node['mule-test']['group']
end

include_recipe 'java::default'

mule_instance 'mule-esb' do
    enterprise_edition node['mule-test']['enterprise']
    home '/usr/local/mule-esb-test'
    env 'test'
    user node['mule-test']['user']
    group node['mule-test']['group']
    action :create
end

mule_instance 'mule-esb-2' do
    enterprise_edition node['mule-test']['enterprise']
    home '/usr/local/mule-esb-test-2'
    env 'test'
    user node['mule-test']['user']
    group node['mule-test']['group']
    action :create
end
