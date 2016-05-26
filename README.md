# mule

Installs Mule Community or Enterprise Edition runtimes on a server.

## Supported Platforms

* Ubuntu 14.04 LTS

## Attributes

* `node['mule']['user']` - The User that will own and run Mule.
* `node['mule']['uid']` - UID for the Mule user.
* `node['mule']['group']` - Group in which the Mule user will be a member.
* `node['mule']['gid']` - GID for the Mule user group.
* `node['mule']['install_java']` - Should this cookbook install java, or leave that up to the user.
* `node['mule']['wrapper_defaults']` - Should the wrapper have sensible defaults if they are not included.

#### `node['mule']['runtimes']`

Attributes for Mule ESB runtimes are set as a list in the `node['mule']['runtimes']` attribute:

```json
{
    "mule": {
        "runtimes": [
            {
                "name": "mule-esb",
                "version": "3.8.0",
                "enterprise_edition": false,
                "license_name": "",
                "mule_source": "/tmp/mule",
                "mule_home": "/usr/local/mule-esb",
                "mule_env": ""
            }
        ]
    }
}
```

* `name` - The name of the Mule ESB service to be installed.
* `version` - The version of Mule ESB to be installed.
* `enterprise_edition` - Optional. Flag determining if this is an Enterprise runtime.
* `license_name` - Optional. The name of the mule license file. A missing attribute will skip license install.
* `mule_source` - The path containing the mule archive and license.
* `mule_home` - Path to the MULE_HOME directory.
* `mule_env` - The MULE_ENV variable, as used by the Mule Runtime.
* `init_heap_size` - Optional. The `wrapper.java.initmemory` parameters in the Tanuki Java Service Wrapper. Defaults to `1024` (m) when not set. If set to 0, the Wrapper will expect you to set the `-Xms` argument in `wrapper_additional`.
* `max_heap_size` - Optional. The `wrapper.java.maxmemory` parameters in the Tanuki Java Service Wrapper. Defaults to `1024` (m) when not set. If set to 0, the Wrapper will expect you to set the `-Xmx` argument in `wrapper_additional`.
* `wrapper_additional` - Optional. An array of strings containing the arguments sent to the JVM through the `wrapper.java.additional.n` settings in the Tanuki Java Service Wrapper.

Recommended arguments to the JVM will have sane defaults for mule if not included:

* `-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-receive-buffer-size=1048576`
* `-Dorg.glassfish.grizzly.nio.transport.TCPNIOTransport.max-send-buffer-size=1048576`
* `-XX:PermSize=256m`
* `-XX:MaxPermSize=256m`
* `-XX:NewSize=512m`
* `-XX:MaxNewSize=512m`
* `-XX:MaxTenuringThreshold=8`

Arguments for the JVM that are set by default, and should not be included:

* `-Dmule.home="%MULE_HOME%"`
* `-Dmule.base="%MULE_HOME%"`
* `-Djava.net.preferIPv4Stack=TRUE`
* `-Dmvel2.disable.jit=TRUE`
* `-XX:+HeapDumpOnOutOfMemoryError`
* `-XX:+AlwaysPreTouch`
* `-XX:+UseParNewGC`

Set the `node['mule']['wrapper_defaults']` argument to false if you don't want defaults and will set everything yourself, but `-Dmule.home="%MULE_HOME%"` and `-Dmule.base="%MULE_HOME%"` will always be set by the cookbook.

More info on the Tanuki Java Service Wrapper is available at: http://wrapper.tanukisoftware.com/doc/english/introduction.html

## Usage

Mule requires a Java Development Kit to run, and it is highly recommended you use Oracle JDK 8 to run Mule ESB. To select Oracle JDK 8 and agree to the license, include the following in your role:

```json
{
    "java": {
        "install_flavor": "oracle",
        "jdk_version": "8",
        "oracle": {
            "accept_oracle_download_terms": true
        }
    }
}
```

Otherwise, the default will be the OpenJDK as selected by the java cookbook.

If you wish to install java yourself, set the `node['mule']['install_java']` attribute to `false`.

Include `mule` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mule::default]"
  ]
}
```

or in a recipe:

```ruby
include_recipe 'mule::default'
```

## License and Authors

Author: Reed McCartney (<reed@hoegg.software>)

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
