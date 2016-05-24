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

* `name` - The name of the Mule ESB service to be installed.</td>
* `version` - The version of Mule ESB to be installed.</td>
* `enterprise_edition` - Optional. Flag determining if this is an Enterprise runtime.
* `license_name` - Optional. The name of the mule license file. A missing attribute will skip license install.
* `mule_source` - The path containing the mule archive and license.
* `mule_home` - Path to the MULE_HOME directory.
* `mule_env` - The MULE_ENV variable, as used by the Mule Runtime.
* `perm_size` - Optional. The `-XX:PermSize=` argument sent to the JVM. Defaults to `256m` when not set.
* `max_perm_size` - Optional. The `-XX:MaxPermSize=` argument sent to the JVM. Defaults to `256m` when not set.
* `new_size` - Optional. The `-XX:NewSize=` argument sent to the JVM. Defaults to `512m` when not set.
* `max_new_size` - Optional. The `-XX:MaxNewSize=` argument sent to the JVM. Defaults to `512m` when not set.
* `init_heap_size` - Optional. The `wrapper.java.initmemory` setting in the Tanuki JSW. Defaults to `1024` (m) when not set.
* `max_heap_size` - Optional. The `wrapper.java.maxmemory` setting in the Tanuki JSW. Defaults to `1024` (m) when not set.

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
