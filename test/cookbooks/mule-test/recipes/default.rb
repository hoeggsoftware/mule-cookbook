mule_base = '/usr/local'
temp = '/tmp/mule'
jdk_install = 'jdk-8u91-linux-x64.tar.gz'
mule_install = 'mule-ee-distribution-standalone-3.8.0.zip'

if node['platform'] == 'ubuntu'
    directory temp do
        recursive true
    end

    user node['mule-test']['user'] do
        supports manage_home: true
        shell '/bin/bash'
        home "/home/#{node['mule-test']['user']}"
        comment 'Mule user'
    end

    group node['mule-test']['group'] do
        members node['mule-test']['user']
    end

    node.default['java']['install_flavor'] = 'oracle'
    node.default['java']['jdk_version'] = '8'
    node.default['java']['jdk']['8']['x86_64']['url'] = "file:///#{temp}/#{jdk_install}"
    node.default['java']['jdk']['8']['x86_64']['checksum'] = '6f9b516addfc22907787896517e400a62f35e0de4a7b4d864b26b61dbe1b7552'

elsif node['platform'] == 'windows'
    include_recipe 'windows::default'
    mule_base = 'C:/Program\ Files/Mule'
    temp = 'C:/tmp/mule'
    jdk_install = 'jdk-8u91-windows-x64.exe'

    directory temp do
        recursive true
    end

    user node['mule-test']['user']

    group node['mule-test']['group'] do
        ignore_failure true
        members node['mule-test']['user']
    end

    node.default['java']['install_flavor'] = 'windows'
    node.default['java']['jdk_version'] = '8'
    node.default['java']['windows']['url'] = "file:///#{temp}/#{jdk_install}"
    node.default['java']['windows']['package_name'] = 'Java(TM) SE Development Kit 8 (64-bit)'
end

aws_s3_file "#{temp}/#{mule_install}" do
    bucket 'hoegg-ci-data'
    remote_path "installs/#{mule_install}"
    aws_access_key node['aws']['access_key']
    aws_secret_access_key node['aws']['secret']
    not_if do ::File.exists?("#{temp}/#{mule_install}") end
end

aws_s3_file "#{temp}/#{jdk_install}" do
    bucket 'hoegg-ci-data'
    remote_path "installs/#{jdk_install}"
    aws_access_key node['aws']['access_key']
    aws_secret_access_key node['aws']['secret']
    not_if do ::File.exists?("#{temp}/#{jdk_install}") end
end

include_recipe 'java::default'

mule_instance 'mule-esb' do
    enterprise_edition true
    home "#{mule_base}/mule-esb-test"
    env 'test'
    user node['mule-test']['user']
    group node['mule-test']['group']
    action :create
end

mule_instance 'mule-esb-2' do
    enterprise_edition true
    home "#{mule_base}/mule-esb-test-2"
    env 'test'
    user node['mule-test']['user']
    group node['mule-test']['group']
    action :create
end
