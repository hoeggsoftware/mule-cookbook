if node['platform'] == 'ubuntu'
    aws_s3_file '/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip' do
        bucket 'hoegg-ci-data'
        remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
        aws_access_key node['aws']['access_key']
        aws_secret_access_key node['aws']['secret']
        not_if do ::File.exists?('/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip') end
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
    node.default['java']['oracle']['accept_oracle_download_terms'] = true
    include_recipe 'java::default'

    mule_instance 'mule-esb' do
        enterprise_edition true
        home '/usr/local/mule-esb-test'
        env 'test'
        user node['mule-test']['user']
        group node['mule-test']['group']
        action :create
    end

    mule_instance 'mule-esb-2' do
        enterprise_edition true
        home '/usr/local/mule-esb-test-2'
        env 'test'
        user node['mule-test']['user']
        group node['mule-test']['group']
        action :create
    end
elsif node['platform'] == 'windows'
    aws_s3_file ENV['TEMP'] + '\\mule-ee-distribution-standalone-3.8.0.zip' do
        bucket 'hoegg-ci-data'
        remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
        aws_access_key node['aws']['access_key']
        aws_secret_access_key node['aws']['secret']
        not_if do ::File.exists?(ENV['TEMP'] + '\\mule-ee-distribution-standalone-3.8.0.zip') end
    end
        aws_s3_file ENV['TEMP'] + '\\mule-ee-distribution-standalone-3.8.0.zip' do
            bucket 'hoegg-ci-data'
            remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
            aws_access_key node['aws']['access_key']
            aws_secret_access_key node['aws']['secret']
            not_if do ::File.exists?(ENV['TEMP'] + '\\mule-ee-distribution-standalone-3.8.0.zip') end
        end

    user node['mule-test']['user']

    group node['mule-test']['group'] do
        ignore_failure true
        members node['mule-test']['user']
    end

    include_recipe 'windows::default'
    node.default['java']['install_flavor'] = 'windows'
    node.default['java']['jdk_version'] = '8'
    include_recipe 'java::default'

    mule_instance 'mule-esb' do
        enterprise_edition true
        home 'c:\\Program Files\\Mule\\mule-esb-test'
        env 'test'
        user node['mule-test']['user']
        group node['mule-test']['group']
        action :create
    end

    mule_instance 'mule-esb-2' do
        enterprise_edition true
        home 'c:\\Program Files\\Mule\\mule-esb-test-2'
        env 'test'
        user node['mule-test']['user']
        group node['mule-test']['group']
        action :create
    end
end
