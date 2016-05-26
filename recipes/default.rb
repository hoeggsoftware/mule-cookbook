if node['mule']['install_java']
    include_recipe 'java::default'
end
if node['mule']['add_user']
    include_recipe 'mule::_user'
end
include_recipe 'mule::install'
