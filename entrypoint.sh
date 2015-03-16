#!/bin/bash
set -e
mkdir -p /usr/share/webapps/owncloud/data/ \
    && cd /usr/share/webapps/owncloud/ \
    && chown root:http  /usr/share/webapps/owncloud/ \
    && chown -R http:http apps/ data/ \
    && chown -R http:http /etc/webapps/owncloud/config/
exec "$@"
