provides :mule_instance, platform: 'windows'

property :name, String, name_attribute: true, required: true
property :archive_name, String
property :version, String, default: '3.8.0'
property :user, String, default: 'mule'
property :group, String, default: 'mule'
property :enterprise_edition, [TrueClass, FalseClass], default: false
property :license, String, default: ''
property :source, String, default: 'C:/tmp/mule'
property :home, String, default: 'C:/Program\ Files/Mule/mule-esb'
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

        install_windows_service

        start_service
    else
        install_community_runtime
        update_wrapper

        install_windows_service

        start_service
    end
end

action_class.class_eval do
    def install_community_runtime
        folder_name = "mule-standalone-#{new_resource.version}"
        archive_name = new_resource.archive_name || "mule-standalone-#{@new_resource.version}.zip"

        windows_zipfile "extract .zip for #{new_resource.name}" do
            path ENV['TEMP']
            source "#{new_resource.source}/#{archive_name}"
            not_if { ::File.exist?(new_resource.home) || ::File.exist?(ENV['TEMP']+"/#{folder_name}") }
        end

        batch "create #{new_resource.home}" do
            code <<-EOH
                xcopy /e /y %TEMP%\\#{folder_name} #{new_resource.home}
                icacls /setowner #{new_resource.user} /t /c /l /q #{new_resource.home}
                EOH
            not_if { ::File.exist?(new_resource.home) }
        end
    end

    def install_enterprise_runtime
        folder_name = "mule-enterprise-standalone-#{new_resource.version}"
        archive_name = new_resource.archive_name || "mule-ee-distribution-standalone-#{@new_resource.version}.zip"

        windows_zipfile "extract .zip for #{new_resource.name}" do
            path ENV['TEMP']
            source "#{new_resource.source}/#{archive_name}"
            not_if { ::File.exist?(new_resource.home) || ::File.exist?(ENV['TEMP']+"/#{folder_name}") }
        end

        batch "create #{new_resource.home}" do
            code <<-EOH
                xcopy /e /y %TEMP%\\#{folder_name} #{new_resource.home}
                icacls /setowner #{new_resource.user} /t /c /l /q #{new_resource.home}
                EOH
            not_if { ::File.exist?(new_resource.home) }
        end
    end

    def install_windows_service
        template "#{new_resource.home}/bin/mule.bat" do
            source 'mule.bat.erb'
            cookbook 'mule'
            variables(
                mule_name: new_resource.name,
                mule_env: new_resource.env
            )
        end

        batch "#{new_resource.home}\\bin\\install.bat"
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
            variables(
                wrapper_additional: new_resource.wrapper_additional,
                init_heap_size: new_resource.init_heap_size,
                max_heap_size: new_resource.max_heap_size
            )
        end
    end

    def start_service
        service new_resource.name do
            action [:start, :enable]
        end
    end

    def install_license
            batch "copy license for #{new_resource.name}" do
            command <<-EOH
            copy #{new_resource.source}\\#{new_resource.license} %TEMP%\\#{new_resource.license}
            icacls /setowner #{new_resource.user} %TEMP%\\#{new_resource.license}
            EOH
            only_if { ::File.exists?("#{new_resource.source}\\#{new_resource.license}") }
        end

        batch "install license for #{new_resource.name}" do
            user new_resource.user
            group new_resource.group
            cwd new_resource.home
            code "#{new_resource.home}\\bin\\mule.bat -installLicense %TEMP%\\#{new_resource.license}"
            only_if { ::File.exists?("%TEMP%\\#{new_resource.license}") }
        end
    end

    def run_amc_setup
        batch "run amc setup for #{new_resource.name}" do
            user new_resource.user
            group new_resource.group
            cwd new_resource.home
            code "#{new_resource.home}\\bin\\amc_setup.bat -H #{new_resource.amc_setup} #{new_resource.name}"
            not_if { ::File.exists?("#{new_resource.home}\\.mule\\.agent\\keystore.jks") }
        end
    end
end
