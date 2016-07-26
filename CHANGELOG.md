# 0.6.1

* wrapper.conf template only runs once to avoid erasing ARM settings after amc_setup.

# 0.6.0

* Change Lightweight Resource Provider to Custom Resource.

# 0.5.0

* Mule Enterprise Runtimes can now register with the Anypoint Platform.
* Added helper module to fetch registration token for amc_setup.

# 0.4.0

* User can now specify the archive_name of the runtime. (Archive containing the runtime to install)

# 0.3.1

* Added whyrun support.
* Fixed some Foodcritic complaints.

# 0.3.0

* Changed Mule installation to a Chef Lightweight Resource Provider rather than a recipe.
* Created a test cookbook and kitchen file for CI.

# 0.2.1

* Remove variables setting uid and gid.

# 0.2.0

* Added the ability to open both .tar.gz and .zip files depending on what is available.
* Added the ability to set arguments to the JVM with a cookbook attribute through the wrapper.conf.

# 0.1.1

* Rename cookbook, and make naming conventions consistent across cookbook.
* Fix some Foodcritic complaints.

# 0.1.0

* Initial release of mule cookbook.
* Supports installing Java, multiple Mule ESB runtimes with Upstart scripts, and enterprise licenses.
