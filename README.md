[ ![Codeship Status for hoeggsoftware/mule-cookbook](https://codeship.com/projects/0e0b98c0-05ef-0134-3846-6e0165e195ed/status?branch=master)](https://codeship.com/projects/154582)
# mule

Installs Mule Community or Enterprise Edition runtimes on a server.

## Supported Platforms

* Ubuntu 14.04 LTS
* Centos 7.2

## Usage

Mule should be run under a separate user with restricted permissions.

```ruby
group 'mule' do
end

user 'mule' do
    supports manage_home: true
    shell '/bin/bash'
    home '/home/mule'
    comment 'Mule user'
    group 'mule'
end
```

Mule requires a Java Development Kit to run, and it is highly recommended you use Oracle JDK 8 to run Mule ESB.

```ruby
include_recipe 'java'
```

Take note of the required node attributes required to download and install Oracle JDK

It is very easy to get started with the Mule LWRP:

```ruby
mule_instance "mule-esb" do
    version '3.8.0'
    user 'mule'
    group 'mule'
end
```

The full syntax for all of the attributes in the Mule provider is:

```ruby
mule_instance "name" do
    amc_setup           String
    archive_name        String
    enterprise_edition  TrueClass, FalseClass
    env                 String
    group               String
    home                String
    init_heap_size      String
    license             String
    max_heap_size       String
    name                String # defaults to 'name' if not specified
    source              String
    user                String
    version             String
    wrapper_additional  Array
    wrapper_defaults    TrueClass, FalseClass
    action              Symbol # defaults to :create if not specified
end
```

#### Anypoint Platform Integration

To register a server with the anypoint platform, the Chef recipe must get a token from Anypoint:

```ruby
Chef::Recipe.send(:include, Mule::Helper)
regToken = amc_setup('Username','Password','Organization Name','Environment Name')
```

And use it to register the newly created runtime with the Anypoint Runtime Manager:

```ruby
mule_instance 'mule-esb' do
    enterprise_edition true
    home '/usr/local/mule-esb'
    env 'test'
    user 'mule'
    group 'mule'
    action :create
    license 'muleLicense.lic'
    amc_setup regToken
end
```

## Actions

This resource has the following actions:

#### `:create`

Default. Creates a Mule Runtime and installs it as a service.

## Attributes

#### `amc_setup`

**Ruby Types:** String

The token used to register with Anypoint resource manager. Should be provided through the `amc_setup` helper method. See Usage. `amc_setup` does not run if `enterprise_edition` is `false`. 

#### `archive_name`

**Ruby Types:** String

The name of the archive containing the Mule runtime. Defaults to `"mule-ee-distribution-standalone-" + version` if `enterprise_edition` is `true` and `"mule-standalone-" + version` if `enterprise_edition` is `false`.

#### `enterprise_edition`

**Ruby Types:** TrueClass, FalseClass

Flag determining if this is an Enterprise runtime. Defaults to `false`.

#### `env`

**Ruby Types:** String

The MULE_ENV variable, as used by the Mule Runtime. Defaults to `'test'`.

#### `group`

**Ruby Types:** String

The group that owns the mule runtime. Defaults to `'mule'`.

#### `home`

**Ruby Types:** String

Path to the MULE_HOME directory. Defaults to `'/usr/local/mule-esb'`.

#### `init_heap_size`

**Ruby Types:** String

The `wrapper.java.initmemory` parameters in the Tanuki Java Service Wrapper. Defaults to `'1024'` (m). If set to `'0'`, the Wrapper will expect you to set the `-Xms` argument in `wrapper_additional`. Otherwise, the JVM will use its own built in defaults.

#### `license`

**Ruby Types:** String

The name of the mule license file. Will not install a license if `enterprise_edition` is set to `false`. Defaults to empty string, which skips the license install.

#### `max_heap_size`

**Ruby Types:** String

The `wrapper.java.maxmemory` parameters in the Tanuki Java Service Wrapper. Defaults to `'1024'` (m). If set to `'0'`, the Wrapper will expect you to set the `-Xmx` argument in `wrapper_additional`. Otherwise, the JVM will use its own built in defaults.

#### `name`

**Ruby Types:** String

The name of the Mule ESB service to be installed. Defaults to the name of the resource block if not set.

#### `source`

**Ruby Types:** String

The path to the folder containing the mule archive and license. Defaults to `'/tmp/mule'`.

#### `user`

**Ruby Types:** String

The user that owns the mule runtime. Defaults to `'mule'`.

#### `version`

**Ruby Types:** String

The version of Mule ESB to be installed. This is a required attribute.

#### `wrapper_additional`

**Ruby Types:** Array

An array of strings containing the arguments sent to the JVM through the `wrapper.java.additional.n` settings in the Tanuki Java Service Wrapper. Recommended arguments to the JVM will have sane defaults for mule if not included:

* `-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=1048576`
* `-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=1048576`
* `-XX:PermSize=256m`
* `-XX:MaxPermSize=256m`
* `-XX:NewSize=512m`
* `-XX:MaxNewSize=512m`
* `-XX:MaxTenuringThreshold=8`

Arguments for the JVM that are set by default and do not need to be included:

* `-Dmule.home="%MULE_HOME%"`
* `-Dmule.base="%MULE_HOME%"`
* `-Djava.net.preferIPv4Stack=TRUE`
* `-Dmvel2.disable.jit=TRUE`
* `-XX:+HeapDumpOnOutOfMemoryError`
* `-XX:+AlwaysPreTouch`
* `-XX:+UseParNewGC`

More info on the Tanuki Java Service Wrapper is available at: http://wrapper.tanukisoftware.com/doc/english/introduction.html

#### `wrapper_defaults`

**Ruby Types:** TrueClass, FalseClass

Set this attributes to false if you don't want defaults and will set everything yourself, but `-Dmule.home="%MULE_HOME%"` and `-Dmule.base="%MULE_HOME%"` will always be set by the cookbook. Defaults to `true`.

More info on the Tanuki Java Service Wrapper is available at: http://wrapper.tanukisoftware.com/doc/english/introduction.html

## License and Authors

Authors: Reed McCartney (<reed@hoegg.software>) and Ryan Hoegg (<ryan@hoegg.software>)

Copyright 2016 Hoegg Software Company

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
