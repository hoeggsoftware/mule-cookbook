default['mule']['user'] = 'mule'
default['mule']['group'] = 'mule'
default['mule']['install_java'] = true
default['mule']['add_user'] = true
default['mule']['wrapper_defaults'] = true

default['mule']['runtimes'] = [
    {
        name: 'mule-esb',
        version: '3.8.0',
        enterprise_edition: false,
        license_name: '',
        mule_source: '/tmp/mule',
        mule_home: '/usr/local/mule-esb',
        mule_env: ''
    }
]
