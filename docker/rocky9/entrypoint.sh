#!/usr/bin/env bash
set -euo pipefail

mkdir -p /run/php-fpm
chown apache:apache /run/php-fpm

# Ensure required def files exist.
if [[ ! -f /var/www/html/htdocs/scielo.def.php && -f /var/www/html/htdocs/scielo.def.php.template ]]; then
  cp /var/www/html/htdocs/scielo.def.php.template /var/www/html/htdocs/scielo.def.php
fi
if [[ ! -f /var/www/html/htdocs/applications/scielo-org/scielo.def.php && -f /var/www/html/htdocs/applications/scielo-org/scielo.def.php.template ]]; then
  cp /var/www/html/htdocs/applications/scielo-org/scielo.def.php.template /var/www/html/htdocs/applications/scielo-org/scielo.def.php
fi

# Force local WXIS endpoint inside container.
sed -ri 's#^SERVER_SCIELO=.*#SERVER_SCIELO=127.0.0.1#' /var/www/html/htdocs/scielo.def.php || true
sed -ri 's#^ENABLED_CACHE=.*#ENABLED_CACHE=0#' /var/www/html/htdocs/scielo.def.php || true
sed -ri 's#^CACHE_STATUS\\s*=.*#CACHE_STATUS = off#' /var/www/html/htdocs/scielo.def.php || true

# Recreate legacy SciELO filesystem layout expected by old defs/scripts.
mkdir -p /home/scielo/www
ln -sfn /var/www/html/htdocs /home/scielo/www/htdocs
ln -sfn /var/www/html/cgi-bin /home/scielo/www/cgi-bin
ln -sfn /var/www/html/proc /home/scielo/www/proc

if [[ ! -e /var/www/html/bases && -d /var/www/html/bases_modelo ]]; then
  ln -sfn /var/www/html/bases_modelo /var/www/html/bases
fi
ln -sfn /var/www/html/bases /home/scielo/www/bases
rm -rf /home/scielo/www/bases/pages/* 2>/dev/null || true

# Compatibility fix for legacy CISIS index naming used by SERAREA in some dumps.
# Some datasets provide serarea.l01/l02 but WXIS expects serarea.ly1/ly2.
if [[ -d /var/www/html/bases/title ]]; then
  if [[ ! -e /var/www/html/bases/title/serarea.ly1 && -e /var/www/html/bases/title/serarea.l01 ]]; then
    ln -sfn /var/www/html/bases/title/serarea.l01 /var/www/html/bases/title/serarea.ly1
  fi
  if [[ ! -e /var/www/html/bases/title/serarea.ly2 && -e /var/www/html/bases/title/serarea.l02 ]]; then
    ln -sfn /var/www/html/bases/title/serarea.l02 /var/www/html/bases/title/serarea.ly2
  fi
  if [[ ! -e /var/www/html/bases/title/serarea.iyp && -e /var/www/html/bases/title/title.iyp ]]; then
    ln -sfn /var/www/html/bases/title/title.iyp /var/www/html/bases/title/serarea.iyp
  fi
fi

php-fpm -D
exec /usr/sbin/httpd -D FOREGROUND
