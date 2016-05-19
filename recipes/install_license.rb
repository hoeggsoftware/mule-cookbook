node['mule']['runtimes'].each do |runtime|
    if runtime['enterprise_edition'] && runtime.has_key?('license_name') && !runtime['license_name'].empty?
        execute 'copy license' do
            command <<-EOH
            cp #{runtime['mule_source']}/#{runtime['license_name']} /tmp/#{runtime['license_name']}
            chown #{node['mule']['user']}:#{node['mule']['group']} /tmp/#{runtime['license_name']}
            EOH
            only_if "[ -e #{runtime['mule_source']}/#{runtime['license_name']} ]"
        end

        execute 'install license' do
            user node['mule']['user']
            group node['mule']['group']
            cwd runtime['mule_home']
            live_stream true
            command "#{runtime['mule_home']}/bin/mule -installLicense /tmp/#{runtime['license_name']}"
            only_if "[ -e /tmp/#{runtime['license_name']} ]"
        end
    end
end

node['mule']['runtimes'].each do |runtime|
    if runtime['enterprise_edition'] && runtime.has_key?('license_name') && !runtime['license_name'].empty?
        execute 'clean up licenses' do
            command "rm #{runtime['mule_source']}/#{runtime['license_name']}"
            only_if "[ -e #{runtime['mule_source']}/#{runtime['license_name']} ]"
        end
    end
end
