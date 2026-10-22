FROM rockylinux:9

# Keep the patched PHP release and its upstream checksum together. Builds fail
# closed if the downloaded source does not match this exact PHP release.
ARG PHP_VERSION=8.5.12
ARG PHP_SHA256=08bc2eba2a588654ade1357174aa646b761556c862dda0678345ee29ed481209

RUN dnf -y --refresh upgrade \
    && dnf -y install --setopt=install_weak_deps=False dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf -y install --allowerasing --setopt=install_weak_deps=False \
    httpd \
    ca-certificates \
    curl \
    libcurl \
    freetype \
    gettext \
    libjpeg-turbo \
    libpng \
    libxml2 \
    libxslt \
    libzip \
    oniguruma \
    openssl-libs \
    readline \
    sqlite-libs \
    zlib \
    autoconf \
    bison \
    gcc \
    gcc-c++ \
    make \
    pkgconf-pkg-config \
    tar \
    xz \
    libcurl-devel \
    freetype-devel \
    gettext-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    libxml2-devel \
    libxslt-devel \
    libzip-devel \
    oniguruma-devel \
    openssl-devel \
    readline-devel \
    sqlite-devel \
    zlib-devel \
    && curl --fail --show-error --silent --location \
        --output /tmp/php.tar.xz \
        "https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz" \
    && echo "${PHP_SHA256}  /tmp/php.tar.xz" | sha256sum --check --strict \
    && mkdir -p /usr/src/php \
    && tar -xJf /tmp/php.tar.xz --strip-components=1 -C /usr/src/php \
    && cd /usr/src/php \
    && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --with-config-file-path=/etc \
        --with-config-file-scan-dir=/etc/php.d \
        --disable-cgi \
        --enable-fpm \
        --with-fpm-user=apache \
        --with-fpm-group=apache \
        --enable-gd \
        --with-freetype \
        --with-jpeg \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --enable-pcntl \
        --enable-posix \
        --enable-soap \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --with-curl \
        --with-gettext \
        --with-libdir=lib64 \
        --with-openssl \
        --with-readline \
        --with-xsl \
        --with-zip \
        --with-zlib \
    && make -j"$(nproc)" \
    && make install \
    && install -d /etc/php.d /etc/php-fpm.d /run/php-fpm \
    && install -m 0644 php.ini-production /etc/php.ini \
    && cp /etc/php-fpm.conf.default /etc/php-fpm.conf \
    && cp /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf \
    && sed -ri \
        -e 's#^user = .*$#user = apache#' \
        -e 's#^group = .*$#group = apache#' \
        -e 's#^listen = .*$#listen = /run/php-fpm/www.sock#' \
        -e 's#^;listen.owner = .*$#listen.owner = apache#' \
        -e 's#^;listen.group = .*$#listen.group = apache#' \
        -e 's#^;listen.mode = .*$#listen.mode = 0660#' \
        /etc/php-fpm.d/www.conf \
    && test "$(php -r 'echo PHP_VERSION;')" = "${PHP_VERSION}" \
    && php -r 'exit(version_compare(PHP_VERSION, "8.5.12", ">=") ? 0 : 1);' \
    && php -r '$required = ["curl", "dom", "gd", "libxml", "mbstring", "mysqli", "pdo_mysql", "simplexml", "xsl", "Zend OPcache"]; foreach ($required as $extension) { if (!extension_loaded($extension)) { fwrite(STDERR, "Missing PHP extension: {$extension}\n"); exit(1); } }' \
    && printf '%s\n' "${PHP_VERSION}" > /etc/scielo-php-version \
    && dnf -y remove \
        autoconf bison gcc gcc-c++ make pkgconf-pkg-config \
        libcurl-devel freetype-devel gettext-devel libjpeg-turbo-devel \
        libpng-devel libxml2-devel libxslt-devel libzip-devel \
        oniguruma-devel openssl-devel readline-devel sqlite-devel zlib-devel \
    && dnf -y --refresh upgrade \
    && (rpm -q vim-minimal && dnf -y remove vim-minimal || true) \
    && dnf clean all \
    && rm -rf /var/cache/dnf /tmp/php.tar.xz /usr/src/php

COPY docker/rocky9/httpd-scielo.conf /etc/httpd/conf.d/scielo.conf
COPY docker/rocky9/php-scielo.ini /etc/php.d/99-scielo.ini
COPY docker/rocky9/entrypoint.sh /usr/local/bin/entrypoint-scielo.sh
COPY docker/rocky9/scielo-instance-check.sh /usr/local/bin/scielo-instance-check.sh

# Reuse the default /cgi-bin/ ScriptAlias, but point it to the project cgi-bin.
RUN sed -ri 's#^[[:space:]]*ScriptAlias /cgi-bin/ ".*"#ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"#' /etc/httpd/conf/httpd.conf \
    && sed -ri 's#<Directory "/var/www/cgi-bin">#<Directory "/var/www/html/cgi-bin">#' /etc/httpd/conf/httpd.conf \
    && mkdir -p /var/www/html \
    && chown -R apache:apache /var/www/html \
    && chmod +x /usr/local/bin/entrypoint-scielo.sh /usr/local/bin/scielo-instance-check.sh

LABEL org.opencontainers.image.version="${PHP_VERSION}" \
      org.opencontainers.image.description="SciELO Web on patched PHP 8.5.12"

EXPOSE 80

CMD ["/usr/local/bin/entrypoint-scielo.sh"]
