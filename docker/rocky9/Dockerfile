FROM rockylinux:9

RUN dnf -y --refresh upgrade \
    && dnf -y install --setopt=install_weak_deps=False \
    https://rpms.remirepo.net/enterprise/remi-release-9.rpm \
    dnf-plugins-core \
    && dnf -y module reset php \
    && dnf -y module enable php:remi-8.5 \
    && dnf -y install --setopt=install_weak_deps=False \
    httpd \
    php \
    php-fpm \
    php-cli \
    php-common \
    php-mysqlnd \
    php-xml \
    php-mbstring \
    php-gd \
    php-opcache \
    php-process \
    && dnf -y --refresh upgrade \
    && (rpm -q vim-minimal && dnf -y remove vim-minimal || true) \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY docker/rocky9/httpd-scielo.conf /etc/httpd/conf.d/scielo.conf
COPY docker/rocky9/php-scielo.ini /etc/php.d/99-scielo.ini
COPY docker/rocky9/entrypoint.sh /usr/local/bin/entrypoint-scielo.sh
COPY docker/rocky9/scielo-instance-check.sh /usr/local/bin/scielo-instance-check.sh

RUN sed -ri 's#^(user|group) = .*$#\1 = apache#' /etc/php-fpm.d/www.conf && \
    sed -ri 's#^listen\.acl_users = .*$#listen.acl_users = apache#' /etc/php-fpm.d/www.conf

# Reuse the default /cgi-bin/ ScriptAlias, but point it to the project cgi-bin.
RUN sed -ri 's#^[[:space:]]*ScriptAlias /cgi-bin/ ".*"#ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"#' /etc/httpd/conf/httpd.conf && \
    sed -ri 's#<Directory "/var/www/cgi-bin">#<Directory "/var/www/html/cgi-bin">#' /etc/httpd/conf/httpd.conf

RUN mkdir -p /var/www/html && \
    chown -R apache:apache /var/www/html && \
    chmod +x /usr/local/bin/entrypoint-scielo.sh /usr/local/bin/scielo-instance-check.sh

EXPOSE 80

CMD ["/usr/local/bin/entrypoint-scielo.sh"]
