# nginx_build_script
A script to build Nginx with the ModSecurity and Headers-More modules.  This script will check for the latest version of Nginx available (by scraping the Nginx download page), compare the version to your currently installed version, and then download and compile a new version if needed.

The script will NOT install the newly compiled version (for safety purposes), but the last line can send an email alerting you of the new version, giving you the freedom to install when convenient.

You can set this up as a cron job so that you will always have the latest version available.

Before first run, clone the ModSecurity-nginx and Headers-More modules into /opt, and build/install a version of Nginx from source.

Example: 
cd /opt; git clone https://github.com/openresty/headers-more-nginx-module.git; git clone https://github.com/SpiderLabs/ModSecurity-nginx.git
wget http://nginx.org/download/nginx-1.15.3.tar.gz && tar xzvf nginx-1.15.3.tar.gz && rm nginx-1.15.3.tar.gz
cd nginx-1.15.3
./configure --user=www-data --group=www-data --with-pcre-jit --with-debug --with-http_ssl_module --with-http_realip_module --add-module=/opt/ModSecurity-nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --add-module=/opt/headers-more-nginx-module

Also, make sure to modify the email address info in the last line (if you want to receive email notifications when a new version has been built).
