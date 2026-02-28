FROM rockylinux:9

RUN dnf -y install \
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
    && dnf clean all

COPY docker/rocky9/httpd-scielo.conf /etc/httpd/conf.d/scielo.conf
COPY docker/rocky9/php-scielo.ini /etc/php.d/99-scielo.ini
COPY docker/rocky9/entrypoint.sh /usr/local/bin/entrypoint-scielo.sh

# Reuse the default /cgi-bin/ ScriptAlias, but point it to the project cgi-bin.
RUN sed -ri 's#^ScriptAlias /cgi-bin/ ".*"#ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"#' /etc/httpd/conf/httpd.conf && \
    sed -ri 's#<Directory "/var/www/cgi-bin">#<Directory "/var/www/html/cgi-bin">#' /etc/httpd/conf/httpd.conf

RUN mkdir -p /var/www/html && \
    chown -R apache:apache /var/www/html && \
    chmod +x /usr/local/bin/entrypoint-scielo.sh

EXPOSE 80

CMD ["/usr/local/bin/entrypoint-scielo.sh"]
