package "tar"
package "unzip"

node['mule']['runtimes'].each do |runtime|
    archive_name = "mule-standalone-#{runtime['version']}"
    folder_name = "mule-standalone-#{runtime['version']}"
    if runtime['enterprise_edition']
        archive_name = "mule-ee-distribution-standalone-#{runtime['version']}"
        folder_name = "mule-enterprise-standalone-#{runtime['version']}"
    else
        archive_name = "mule-standalone-#{runtime['version']}"
        folder_name = "mule-standalone-#{runtime['version']}"
    end

    if File.exist?("#{runtime['mule_source']}/#{archive_name}.tar.gz")
        execute 'extract .tar.gz' do
            command "tar -C /tmp/ -zxf #{runtime['mule_source']}/#{archive_name}.tar.gz"
            not_if "[ -e /tmp/#{folder_name} ] || [ -e #{runtime['mule_home']} ]"
        end
    else
        execute 'extract .zip' do
            command "unzip -d /tmp/ #{runtime['mule_source']}/#{archive_name}"
            not_if "[ -e /tmp/#{folder_name} ] || [ -e #{runtime['mule_home']} ]"
        end
    end

    execute 'create mule_home' do
        command <<-EOH
        cp -pR /tmp/#{folder_name}/ #{runtime['mule_home']}
        chown -R #{node['mule']['user']}:#{node['mule']['group']} #{runtime['mule_home']}
        EOH
        not_if "[ -e #{runtime['mule_home']} ]"
    end

    template "/etc/default/#{runtime['name']}" do
        owner node['mule']['user']
        group node['mule']['group']
        source 'mule.erb'
        mode 0644
        variables(
            mule_home: runtime['mule_home'],
            mule_env: runtime['mule_env']
        )
    end

    template "/etc/init/#{runtime['name']}.conf" do
        source 'mule.conf.erb'
        mode 0644
        variables(
            user: node['mule']['user'],
            group: node['mule']['group'],
            name: runtime['name']
        )
    end

    template "#{runtime['mule_home']}/conf/wrapper.conf" do
        source 'wrapper.conf.erb'
        mode 0644
        variables(
            perm_size: runtime['perm_size'] || "256m",
            max_perm_size: runtime['max_perm_size'] || "256m",
            new_size: runtime['new_size'] || "512m",
            max_new_size: runtime['max_new_size'] || "512m",
            init_heap_size: runtime['init_heap_size'] || "1024",
            max_heap_size: runtime['max_heap_size'] || "1024"
        )
    end
end

node['mule']['runtimes'].each do |runtime|
    folder_name = "mule-standalone-#{runtime['version']}"
    if runtime['enterprise_edition']
        folder_name = "mule-enterprise-standalone-#{runtime['version']}"
    else
        folder_name = "mule-standalone-#{runtime['version']}"
    end

    execute 'clean up /tmp' do
        command "rm -rf /tmp/#{folder_name}"
        only_if "[ -e /tmp/#{folder_name} ]"
    end
end

include_recipe 'mule::install_license'

node['mule']['runtimes'].each do |runtime|
    service runtime['name'] do
        action [:start, :enable]
    end
end
