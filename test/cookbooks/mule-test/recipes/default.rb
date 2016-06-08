directory "/tmp/mule"

aws_s3_file "/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip" do
    bucket 'hoegg-ci-data'
    remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
    aws_access_key node[:aws][:access_key]
    aws_secret_access_key node[:aws][:secret]
    not_if do ::File.exists?('/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip') end
end

group node['mule-test']['group'] do
end

user node['mule-test']['user'] do
    supports manage_home: true
    shell '/bin/bash'
    home "/home/#{node['mule-test']['user']}"
    comment 'Mule user'
    group node['mule-test']['group']
end

include_recipe 'java::default'

mule_instance "mule-esb" do
    version "3.8.0"
    enterprise_edition true
    home "/usr/local/mule-esb-test"
    env "test"
    user node['mule-test']['user']
    group node['mule-test']['group']
    action :create
end
