name             'mule'
maintainer       'Reed McCartney'
maintainer_email 'reed@hoegg.software'
license          'Apache-2.0'
description      'Installs/Configures Mule ESB'
long_description 'Installs/Configures Mule ESB'
version          '0.8.0'
chef_version     '>=12'

supports 'ubuntu'
supports 'centos'
depends 'compat_resource'

source_url 'https://github.com/hoeggsoftware/mule-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/hoeggsoftware/mule-cookbook/issues' if respond_to?(:issues_url)
