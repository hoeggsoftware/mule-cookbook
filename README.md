# mule

Installs Mule Community Edition and Enterprise Edition.

## Supported Platforms

- Ubuntu 14.04 LTS

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mule']['user']</tt></td>
    <td>String</td>
    <td>The User that will own and run Mule.</td>
    <td><tt>mule</tt></td>
  </tr>
  <tr>
    <td><tt>['mule']['uid']</tt></td>
    <td>Integer</td>
    <td>UID for the Mule user.</td>
    <td><tt>4000</tt></td>
  </tr>
  <tr>
    <td><tt>['mule']['group']</tt></td>
    <td>String</td>
    <td>Group in which the Mule user will be a member.</td>
    <td><tt>mule</tt></td>
  </tr>
  <tr>
    <td><tt>['mule']['gid']</tt></td>
    <td>Integer</td>
    <td>GID for the Mule user group.</td>
    <td><tt>4000</tt></td>
  </tr>
  <tr>
    <td><tt>['mule']['install_java']</tt></td>
    <td>Boolean</td>
    <td>Should this cookbook install java, or leave that up to the user.</td>
    <td><tt>true</tt></td>
  </tr>
</table>

#### ['mule']['runtimes']

```json
{
    "runtimes": [
        {
            "name": "mule-esb",
            "version": "3.8.0",
            "enterprise_edition": false,
            "license_name": "",
            "mule_source": "/tmp/mule",
            "mule_home": "/usr/local/mule-enterprise-standalone-3.7.3",
            "mule_env": ""
        }
    ]
}
```

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>name</tt></td>
    <td>String</td>
    <td>The name of the Mule ESB service to be installed.</td>
    <td><tt>"mule-esb"</tt></td>
  </tr>
  <tr>
    <td><tt>version</tt></td>
    <td>String</td>
    <td>The version of Mule ESB to be installed.</td>
    <td><tt>"3.8.0"</tt></td>
  </tr>
  <tr>
    <td><tt>enterprise_edition</tt></td>
    <td>String</td>
    <td>Is this the Enterprise Edition of mule.</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>license_name</tt></td>
    <td>String</td>
    <td>The name of the mule license file. [1]</td>
    <td><tt>""</tt></td>
  </tr>
  <tr>
    <td><tt>mule_source</tt></td>
    <td>String</td>
    <td>The path containing the mule archive and license.</td>
    <td><tt>"/mule"</tt></td>
  </tr>
  <tr>
    <td><tt>mule_home</tt></td>
    <td>String</td>
    <td>The path to the MULE_HOME.</td>
    <td><tt>"/usr/local/mule-enterprise-standalone-3.7.3"</tt></td>
  </tr>
  <tr>
    <td><tt>mule_env</tt></td>
    <td>Integer</td>
    <td>The MULE_ENV variable.</td>
    <td><tt>""</tt></td>
  </tr>
</table>

1. Missing or empty values will skip the license install.

## Usage

Mule requires a Java Development Kit to run, and it is highly recommended you use Oracle JDK 8 to run Mule ESB. To select Oracle JDK 8 and agree to the license, include the following in your role:

```ruby
override_attributes({
    java: {
        install_flavor: 'oracle',
        jdk_version: '8',
        oracle: {
            accept_oracle_download_terms: true
        }
    }
})
```

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
