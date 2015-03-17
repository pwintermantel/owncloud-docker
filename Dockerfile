FROM base/arch

MAINTAINER Philipp Wintermantel <philipp@wintermantel.org>


RUN pacman --noconfirm -Sy nginx

RUN pacman --noconfirm -Sy php \
                           php-mcrypt \
                           php-gd \
                           php-apcu \
                           php-pgsql \
                           php-sqlite \
                           php-intl \
                           uwsgi-plugin-php


RUN pacman --noconfirm -Sy ffmpeg 

RUN pacman --noconfirm -Sy owncloud \
                           owncloud-app-bookmarks \
                           owncloud-app-calendar \
                           owncloud-app-contacts 

RUN pacman --noconfirm -Sy supervisor



 #   && chown root:http .htaccess \
 #   && chown root:http data/.htaccess \
 #   && chmod 0644 .htaccess \
 #   && chmod 0644 data/.htaccess


ADD config/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD config/etc/uwsgi/owncloud.ini /etc/uwsgi/owncloud.ini
ADD config/etc/supervisor.d/owncloud.ini /etc/supervisor.d/owncloud.ini
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

VOLUME ["/usr/share/webapps/owncloud/apps"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf" ]
