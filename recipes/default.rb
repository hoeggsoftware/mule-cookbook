include_recipe 'apt::default'
if node['mule']['install_java']
    include_recipe 'java::default'
end

include_recipe 'mule::_user'
include_recipe 'mule::install'
