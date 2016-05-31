directory "/tmp/mule"

# Secret Access Key:
# 
aws_s3_file "/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip" do
    bucket 'hoegg-ci-data'
    remote_path 'installs/mule-ee-distribution-standalone-3.8.0.zip'
    aws_access_key node[:aws][:access_key]
    aws_secret_access_key node[:aws][:secret]
    #not_if do ::File.exists?('/tmp/mule/mule-ee-distribution-standalone-3.8.0.zip') end
end

include_recipe 'mule::default'
