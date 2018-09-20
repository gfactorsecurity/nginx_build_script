# nginx_build_script
A script to build Nginx with the ModSecurity and Headers-More modules.  This script will check for the latest version of Nginx available (by scraping the Nginx download page), compare the version to your currently installed version, and then download and compile a new version if needed.

The script will NOT install the newly compiled version (for safety purposes), but the last line can send an email alerting you of the new version, giving you the freedom to install when convenient.

You can set this up as a cron job so that you will always have the latest version available.

Before first run, clone the ModSecurity-nginx and Headers-More modules into /opt
Example: cd /opt; git clone https://github.com/openresty/headers-more-nginx-module.git; git clone https://github.com/SpiderLabs/ModSecurity-nginx.git

Also, make sure to modify the email address info in the last line (if you want to receive email notifications when a new version has been built).
