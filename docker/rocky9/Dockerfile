FROM rockylinux:9

# Keep the patched PHP release and its upstream checksum together. Builds fail
# closed if the downloaded source does not match this exact PHP release.
ARG PHP_VERSION=8.5.13
ARG PHP_SHA256=607602acaf0c3061818e9916ec44a058e8b3d43959a83862b9cd3ec7bf5b785f
ARG HTTPD_VERSION=2.4.71
ARG HTTPD_SHA256=6b0433674ded858d2ac01e95345935ce127d5d287471762f0a7f10f4969cbfe8

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
    apr-devel \
    apr-util-devel \
    bison \
    brotli-devel \
    expat-devel \
    gcc \
    gcc-c++ \
    libnghttp2-devel \
    make \
    pcre2-devel \
    pkgconf-pkg-config \
    redhat-rpm-config \
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
        --output /tmp/httpd.tar.gz \
        "https://downloads.apache.org/httpd/httpd-${HTTPD_VERSION}.tar.gz" \
    && echo "${HTTPD_SHA256}  /tmp/httpd.tar.gz" | sha256sum --check --strict \
    && mkdir -p /usr/src/httpd \
    && tar -xzf /tmp/httpd.tar.gz --strip-components=1 -C /usr/src/httpd \
    && cd /usr/src/httpd \
    && ./configure \
        --prefix=/opt/httpd \
        --enable-so \
        --enable-mods-shared=reallyall \
        --enable-mpms-shared=all \
        --with-mpm=event \
        --enable-ssl \
        --enable-http2 \
    && make -j"$(nproc)" \
    && make install \
    && rm -f /etc/httpd/modules \
    && ln -s /opt/httpd/modules /etc/httpd/modules \
    && rm -f /etc/httpd/conf.modules.d/00-systemd.conf \
    && /opt/httpd/bin/httpd -v | grep -Fq "Apache/${HTTPD_VERSION}" \
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
    && php -r 'exit(version_compare(PHP_VERSION, "8.5.13", ">=") ? 0 : 1);' \
    && php -r '$required = ["curl", "dom", "gd", "libxml", "mbstring", "mysqli", "pdo_mysql", "simplexml", "xsl", "Zend OPcache"]; foreach ($required as $extension) { if (!extension_loaded($extension)) { fwrite(STDERR, "Missing PHP extension: {$extension}\n"); exit(1); } }' \
    && printf '%s\n' "${PHP_VERSION}" > /etc/scielo-php-version \
    && cp -a /etc/httpd /tmp/httpd-runtime-config \
    && dnf -y remove httpd httpd-core httpd-tools \
    && rm -rf /etc/httpd \
    && mv /tmp/httpd-runtime-config /etc/httpd \
    && install -d -o apache -g apache /var/log/httpd /run/httpd \
    && dnf -y remove \
        autoconf apr-devel apr-util-devel bison brotli-devel expat-devel \
        gcc gcc-c++ libnghttp2-devel make pcre2-devel pkgconf-pkg-config \
        redhat-rpm-config \
        libcurl-devel freetype-devel gettext-devel libjpeg-turbo-devel \
        libpng-devel libxml2-devel libxslt-devel libzip-devel \
        oniguruma-devel openssl-devel readline-devel sqlite-devel zlib-devel \
    && dnf -y install --setopt=install_weak_deps=False \
        apr apr-util mailcap glibc.i686 libstdc++.i686 \
    && dnf -y --refresh upgrade \
    && (rpm -q vim-minimal && dnf -y remove vim-minimal || true) \
    && dnf clean all \
    && rm -rf \
        /var/cache/dnf \
        /tmp/httpd.tar.gz \
        /tmp/php.tar.xz \
        /usr/src/httpd \
        /usr/src/php

COPY docker/rocky9/httpd-scielo.conf /etc/httpd/conf.d/scielo.conf
COPY docker/rocky9/php-scielo.ini /etc/php.d/99-scielo.ini
COPY docker/rocky9/php-fpm-scielo.conf /etc/php-fpm.d/zz-scielo.conf
COPY docker/rocky9/entrypoint.sh /usr/local/bin/entrypoint-scielo.sh
COPY docker/rocky9/scielo-instance-check.sh /usr/local/bin/scielo-instance-check.sh
COPY docker/rocky9/health.php /opt/scielo-health/health.php

# Reuse the default /cgi-bin/ ScriptAlias, but point it to the project cgi-bin.
RUN sed -ri 's#^[[:space:]]*ScriptAlias /cgi-bin/ ".*"#ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"#' /etc/httpd/conf/httpd.conf \
    && sed -ri 's#<Directory "/var/www/cgi-bin">#<Directory "/var/www/html/cgi-bin">#' /etc/httpd/conf/httpd.conf \
    && rm -f /usr/sbin/httpd \
    && ln -s /opt/httpd/bin/httpd /usr/sbin/httpd \
    && mkdir -p /var/www/html/htdocs /var/www/html/cgi-bin \
    && chown -R apache:apache /var/www/html \
    && chmod 0644 /opt/scielo-health/health.php \
    && chmod +x /usr/local/bin/entrypoint-scielo.sh /usr/local/bin/scielo-instance-check.sh \
    && ! rpm -q httpd \
    && test -s /etc/mime.types \
    && php -l /opt/scielo-health/health.php >/dev/null \
    && /usr/sbin/httpd -v | grep -Fq "Apache/${HTTPD_VERSION}" \
    && /opt/httpd/bin/httpd -d /etc/httpd -f conf/httpd.conf -t

LABEL org.opencontainers.image.version="${PHP_VERSION}" \
      org.opencontainers.image.httpd.version="${HTTPD_VERSION}" \
      org.opencontainers.image.description="SciELO Web on patched PHP 8.5.13"

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl --fail --silent --show-error --max-time 8 http://127.0.0.1/health.php || exit 1

CMD ["/usr/local/bin/entrypoint-scielo.sh"]
