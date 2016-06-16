use_inline_resources

def whyrun_supported?
  true
end

action :create do
    if @current_resource.exists
        Chef::Log.info "#{ @new_resource } already exists - nothing to do."
    else
        converge_by("Create #{ @new_resource }") do
            create_mule_runtime
        end
        if @current_resource.enterprise_edition && !@current_resource.license.empty?
            converge_by("Install license for #{ @new_resource }") do
                install_license
            end
        end
    end
end

def load_current_resource
    @current_resource = Chef::Resource::MuleInstance.new(@new_resource.name)
    @current_resource.name(@new_resource.name)
    if @new_resource.enterprise_edition
        @current_resource.archive_name(@new_resource.archive_name || "mule-ee-distribution-standalone-#{@new_resource.version}")
    else
        @current_resource.archive_name(@new_resource.archive_name || "mule-standalone-#{@new_resource.version}")
    end
    @current_resource.version(@new_resource.version)
    @current_resource.user(@new_resource.user)
    @current_resource.group(@new_resource.group)
    @current_resource.enterprise_edition(@new_resource.enterprise_edition)
    @current_resource.license(@new_resource.license)
    @current_resource.source(@new_resource.source)
    @current_resource.home(@new_resource.home)
    @current_resource.env(@new_resource.env)
    @current_resource.init_heap_size(@new_resource.init_heap_size)
    @current_resource.max_heap_size(@new_resource.max_heap_size)
    @current_resource.wrapper_defaults(@new_resource.wrapper_defaults)
    @current_resource.wrapper_additional(@new_resource.wrapper_additional)
    if ::File.exist?(@current_resource.home)
        @current_resource.exists = true
    else
        @current_resource.exists = false
    end
end

def create_mule_runtime
    package 'tar'
    package 'unzip'
    archive_name = "mule-standalone-#{new_resource.version}"
    folder_name = "mule-standalone-#{new_resource.version}"

    if new_resource.enterprise_edition
        archive_name = "mule-ee-distribution-standalone-#{new_resource.version}"
        folder_name = "mule-enterprise-standalone-#{new_resource.version}"
    end
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
    end

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
