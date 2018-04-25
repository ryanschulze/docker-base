#!/usr/bin/env bash

# execute any pre-init scripts, useful for images based on this image
for file in /opt/utils/pre-init.d/*sh; do
	if [[ -e "${file}" ]]; then
		printf "[i] pre-init.d - processing %s\n" "${file}"
		. "${file}"
	fi
done

cat <<EOD >/etc/lighttpd/lighttpd.conf
server.port          = $APP_PORT
server.username      = "lighttpd"
server.groupname     = "lighttpd"
server.document-root = "/app"
server.errorlog	     = "/dev/stdout"
dir-listing.activate = "disable"
index-file.names     = ( "index.html" )
mimetype.assign      = (
  ".html" => "text/html",
  ".txt"  => "text/plain",
  ".css"  => "text/css",
  ".js"   => "application/x-javascript",
  ".jpg"  => "image/jpeg",
  ".jpeg" => "image/jpeg",
  ".json" => "application/json",	
  ".gif"  => "image/gif",
  ".png"  => "image/png",
  ".svg"  => "image/svg+xml",
  ".txt"  => "text/plain",	
  ".xml"  => "application/xml",
  ".zip"  => "application/zip",
  ".gz"   => "application/x-gzip",	
  "" => "application/octet-stream"
)
EOD

if [[ "${WEBSERVER_UID}" != '' ]]; then
	usermod -u ${WEBSERVER_UID} lighttpd
fi

# execute any pre-exec scripts, useful for images based on this image
for file in /opt/utils/pre-exec.d/*sh; do
	if [[ -e "${file}" ]]; then
		printf "[i] pre-exec.d - processing %s\n" "${file}"
		. "${file}"
	fi
done

echo "[i] Starting daemon..."
# run lighttpd daemon
exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
