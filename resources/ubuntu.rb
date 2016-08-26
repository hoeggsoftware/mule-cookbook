provides :mule_instance, platform: 'ubuntu'

property :name, String, name_attribute: true, required: true
property :archive_name, String
property :version, String, default: '3.8.0'
property :user, String, default: 'mule'
property :group, String, default: 'mule'
property :enterprise_edition, [TrueClass, FalseClass], default: false
property :license, String, default: ''
property :source, String, default: '/tmp/mule'
property :home, String, default: '/usr/local/mule-esb'
property :env, String, default: 'test'
property :init_heap_size, String, default: '1024'
property :max_heap_size, String, default: '1024'
property :wrapper_additional, Array, default: []
property :wrapper_defaults, [TrueClass, FalseClass], default: true
property :amc_setup, String, default: ''

action :create do
    if new_resource.enterprise_edition
        install_enterprise_runtime
        update_wrapper

        if !new_resource.license.empty?
            install_license
        end

        if !new_resource.amc_setup.empty?
            run_amc_setup
        end

        install_upstart_service

        start_service
    else
        install_community_runtime
        update_wrapper

        install_upstart_service

        start_service
    end
end

action_class.class_eval do
    def install_community_runtime
        package 'tar'
        package 'unzip'

        archive_name = "mule-standalone-#{new_resource.version}"
        folder_name = "mule-standalone-#{new_resource.version}"
        archive_name = new_resource.archive_name || archive_name

        if ::File.exist?("#{new_resource.source}/#{archive_name}.tar.gz")
            execute "extract .tar.gz for #{new_resource.name}" do
                command "tar -C /tmp/ -zxf #{new_resource.source}/#{archive_name}.tar.gz"
                not_if "[ -e /tmp/#{folder_name} ] || [ -e #{new_resource.home} ]"
            end
        else
            execute "extract .zip for #{new_resource.name}" do
                command "unzip -d /tmp/ #{new_resource.source}/#{archive_name}"
                not_if "[ -e /tmp/#{folder_name} ] || [ -e #{new_resource.home} ]"
            end
        end

        execute "create #{new_resource.home}" do
            command <<-EOH
            cp -pR /tmp/#{folder_name}/ #{new_resource.home}
            chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.home}
            EOH
            not_if "[ -e #{new_resource.home} ]"
        end
    end

    def install_enterprise_runtime
        package 'tar'
        package 'unzip'

        archive_name = "mule-ee-distribution-standalone-#{new_resource.version}"
        folder_name = "mule-enterprise-standalone-#{new_resource.version}"
        archive_name = new_resource.archive_name || archive_name

        if ::File.exist?("#{new_resource.source}/#{archive_name}.tar.gz")
            execute "extract .tar.gz for #{new_resource.name}" do
                command "tar -C /tmp/ -zxf #{new_resource.source}/#{archive_name}.tar.gz"
                not_if "[ -e /tmp/#{folder_name} ] || [ -e #{new_resource.home} ]"
            end
        else
            execute "extract .zip for #{new_resource.name}" do
                command "unzip -d /tmp/ #{new_resource.source}/#{archive_name}"
                not_if "[ -e /tmp/#{folder_name} ] || [ -e #{new_resource.home} ]"
            end
        end

        execute "create #{new_resource.home}" do
            command <<-EOH
            cp -pR /tmp/#{folder_name}/ #{new_resource.home}
            chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.home}
            EOH
            not_if "[ -e #{new_resource.home} ]"
        end
    end

    def install_upstart_service
        template "/etc/default/#{new_resource.name}" do
            owner new_resource.user
            group new_resource.group
            source 'mule.erb'
            cookbook 'mule'
            mode 0644
            variables(
                mule_home: new_resource.home,
                mule_env: new_resource.env
            )
        end

        template "/etc/init/#{new_resource.name}.conf" do
            source 'mule.conf.erb'
            cookbook 'mule'
            mode 0644
            variables(
                user: new_resource.user,
                group: new_resource.group,
                name: new_resource.name
            )
        end
    end

    def update_wrapper
        if new_resource.wrapper_defaults
            if !new_resource.wrapper_additional.join.include? '-Djava.net.preferIPv4Stack=TRUE'
                new_resource.wrapper_additional.push('-Djava.net.preferIPv4Stack=TRUE')
            end

            if !new_resource.wrapper_additional.join.include? '-Dmvel2.disable.jit=TRUE'
                new_resource.wrapper_additional.push('-Dmvel2.disable.jit=TRUE')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:+HeapDumpOnOutOfMemoryError'
                new_resource.wrapper_additional.push('-XX:+HeapDumpOnOutOfMemoryError')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:+AlwaysPreTouch'
                new_resource.wrapper_additional.push('-XX:+AlwaysPreTouch')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:+UseParNewGC'
                new_resource.wrapper_additional.push('-XX:+UseParNewGC')
            end

            if !new_resource.wrapper_additional.join.include? '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size='
                new_resource.wrapper_additional.push('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=1048576')
            end

            if !new_resource.wrapper_additional.join.include? '-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size='
                new_resource.wrapper_additional.push('-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=1048576')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:PermSize='
                new_resource.wrapper_additional.push('-XX:PermSize=256m')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:MaxPermSize='
                new_resource.wrapper_additional.push('-XX:MaxPermSize=256m')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:NewSize='
                new_resource.wrapper_additional.push('-XX:NewSize=512m')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:MaxNewSize='
                new_resource.wrapper_additional.push('-XX:MaxNewSize=512m')
            end

            if !new_resource.wrapper_additional.join.include? '-XX:MaxTenuringThreshold='
                new_resource.wrapper_additional.push('-XX:MaxTenuringThreshold=8')
            end
        end

        template "#{new_resource.home}/conf/wrapper.conf" do
            source 'wrapper.conf.erb'
            cookbook 'mule'
            mode 0644
            variables(
                wrapper_additional: new_resource.wrapper_additional,
                init_heap_size: new_resource.init_heap_size,
                max_heap_size: new_resource.max_heap_size
            )
            action :nothing
        end

        file "#{new_resource.home}/conf/wrapper.conf.lock" do
            action :create_if_missing
            notifies :create, "template[#{new_resource.home}/conf/wrapper.conf]", :immediately
        end
    end

    def start_service
        service new_resource.name do
            action [:start, :enable]
        end
    end

    def install_license
        execute "copy license for #{new_resource.name}" do
            command <<-EOH
            cp #{new_resource.source}/#{new_resource.license} /tmp/#{new_resource.license}
            chown #{new_resource.user}:#{new_resource.group} /tmp/#{new_resource.license}
            EOH
            only_if "[ -e #{new_resource.source}/#{new_resource.license} ]"
        end

        execute "install license for #{new_resource.name}" do
            user new_resource.user
            group new_resource.group
            cwd new_resource.home
            live_stream true
            command "#{new_resource.home}/bin/mule -installLicense /tmp/#{new_resource.license}"
            only_if "[ -e /tmp/#{new_resource.license} ]"
        end
    end

    def run_amc_setup
        execute "run amc setup for #{new_resource.name}" do
            user new_resource.user
            group new_resource.group
            cwd new_resource.home
            live_stream true
            command "#{new_resource.home}/bin/amc_setup -H #{new_resource.amc_setup} #{new_resource.name}"
            not_if "[ -e #{new_resource.home}/.mule/.agent/keystore.jks ]"
        end
    end
end
