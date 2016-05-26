group node['mule']['group'] do
end

user node['mule']['user'] do
    supports manage_home: true
    shell '/bin/bash'
    home "/home/#{node['mule']['user']}"
    comment 'Mule user'
    group node['mule']['group']
end
