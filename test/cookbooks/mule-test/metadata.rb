# encoding: utf-8

name 'mule-test'
maintainer 'Ryan Hoegg'
maintainer_email 'ryan@hoegg.software'
license 'Apache 2.0'
description 'Mule ESB and API Gateway On Premise Wrapper Cookbook'

version '0.1.0'

supports 'ubuntu'

depends 'aws' ,'~> 3.3.3'
depends 'mule'
depends 'apt', '~> 3.0.0'
depends 'java', '~> 1.39.0'
