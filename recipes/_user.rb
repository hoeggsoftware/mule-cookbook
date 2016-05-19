group node['mule']['group'] do
    gid node['mule']['gid']
end

user node['mule']['user'] do
    supports manage_home: true
    shell '/bin/bash'
    home "/home/#{node['mule']['user']}"
    comment 'Mule user'
    uid node['mule']['uid']
    gid node['mule']['gid']
end
