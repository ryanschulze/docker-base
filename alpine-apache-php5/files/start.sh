#!/usr/bin/env bash

# execute any pre-init scripts, useful for images based on this image
for file in /opt/utils/pre-init.d/*sh; do
	if [[ -e "${file}" ]]; then
		printf "[i] pre-init.d - processing %s\n" "${file}"
		. "${file}"
	fi
done

while read -r pattern
do
    sedscript+="$pattern;"
done <<EOD
s@#LoadModule\ rewrite_module@LoadModule\ rewrite_module@
s@#LoadModule\ deflate_module@LoadModule\ deflate_module@
s@#LoadModule\ expires_module@LoadModule\ expires_module@
s@^DocumentRoot \".*@DocumentRoot \"/app/$WEBAPP_ROOT\"@g
s@/var/www/localhost/htdocs@/app/$WEBAPP_ROOT@
EOD

sed -ie "${sedscript}" /etc/apache2/httpd.conf
printf "\n<Directory \"/app${WEBAPP_ROOT}\">\n\tAllowOverride All\n</Directory>\nServerName localhost\n" >> /etc/apache2/httpd.conf

if [[ "${WEBSERVER_UID}" != '' ]]; then
	usermod -u ${WEBSERVER_UID} apache
fi

# execute any pre-exec scripts, useful for images based on this image
for file in /opt/utils/pre-exec.d/*sh; do
	if [[ -e "${file}" ]]; then
		printf "[i] pre-exec.d - processing %s\n" "${file}"
		. "${file}"
	fi
done

echo "[i] Starting daemon..."
# run apache httpd daemon
exec httpd -D FOREGROUND
