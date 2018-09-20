#!/bin/bash

cd /opt/

latest_nginx_version=$(curl -s http://nginx.org/en/download.html | sed 's/\/download\/nginx/\n\/download\/nginx/'g | grep tar.gz\" | cut -d'"' -f1 | head -n1 | sed 's/\/download\/nginx-//g' | sed 's/\.tar\.gz//g')

echo "latest nginx version: $latest_nginx_version"
echo "checking for nginx $latest_nginx_version locally"

installed_nginx_version=$(nginx -v 2>&1 | cut -d'/' -f2)
echo "nginx version installed: $installed_nginx_version"

#latest_nginx_version="1.14.0"

if [ "$installed_nginx_version" == "$latest_nginx_version" ]; then
	echo "latest version already installed. exiting..."
	exit 1
fi

if [ ! -d "/opt/nginx-$nginx_version" ]; then
	echo "nginx $latest_nginx_version build folder not found. downloading..."
	wget "http://nginx.org/download/nginx-$latest_nginx_version.tar.gz"
	tar xzvf "nginx-$latest_nginx_version.tar.gz"
	rm "nginx-$latest_nginx_version.tar.gz"
else
	echo "nginx $latest_nginx_version build folder found. using local copy"
fi

echo "updating headers-more-nginx module..."
cd /opt/headers-more-nginx-module
git pull

echo "updating ModSecurity-nginx module..."
cd /opt/ModSecurity-nginx
git pull

echo "configuring nginx settings..."
cd "/opt/nginx-$latest_nginx_version"

./configure --user=www-data --group=www-data --with-pcre-jit --with-debug --with-http_ssl_module --with-http_realip_module --add-module=/opt/ModSecurity-nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --add-module=/opt/headers-more-nginx-module

echo "building nginx..."
make -j4

echo "done"
echo "to install, move to directory /opt/nginx-$latest_nginx_version and run 'make install'"

#edit sender and recipient email addresses below, along with server name (in message body)
echo -en "To: Recipient@company.com\nSubject: New version of Nginx available for install on <server_name>\n\nNginx $latest_nginx_version has been compiled on <server_name>.  Please log in and (as root) run 'make install' from the '/opt/nginx-$latest_nginx_version' folder." | ssmtp -FSender@company.com -fSender@company.com Recipient@company.com
