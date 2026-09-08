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
for def_file in iah.def title.def article.def sendmail.conf; do
  if [[ ! -f "/var/www/html/htdocs/iah/${def_file}" && -f "/var/www/html/htdocs/iah/${def_file}.template" ]]; then
    sed 's#/var/wwww/html#/var/www/html#g' "/var/www/html/htdocs/iah/${def_file}.template" > "/var/www/html/htdocs/iah/${def_file}"
  fi
done

# Values supplied by the environment override scielo.def.php. Missing or empty
# environment variables preserve the instance configuration already on disk.
SCIELO_DEF_FILE=/var/www/html/htdocs/scielo.def.php
if [[ ! -f "$SCIELO_DEF_FILE" ]]; then
  echo "Missing $SCIELO_DEF_FILE and no template was available to create it" >&2
  exit 1
fi

read_def_value() {
  local key="$1"
  LC_ALL=C sed -n "s#^${key}[[:space:]]*=[[:space:]]*##p" "$SCIELO_DEF_FILE" | head -n 1
}

write_def_value() {
  local key="$1"
  local value="$2"
  local section="$3"
  if LC_ALL=C grep -q "^${key}[[:space:]]*=" "$SCIELO_DEF_FILE"; then
    LC_ALL=C sed -ri "s#^${key}[[:space:]]*=.*#${key}=${value}#" "$SCIELO_DEF_FILE"
  else
    LC_ALL=C sed -ri "/^\[${section}\]$/a${key}=${value}" "$SCIELO_DEF_FILE"
  fi
}

SERVER_SCIELO_FILE_VALUE="$(read_def_value SERVER_SCIELO)"
SERVER_SCIELO_VALUE="${SERVER_SCIELO:-$SERVER_SCIELO_FILE_VALUE}"
SERVER_SCIELO_VALUE="${SERVER_SCIELO_VALUE:-127.0.0.1}"
if [[ ! "$SERVER_SCIELO_VALUE" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*(:[0-9]{1,5})?$ ]]; then
  echo "Invalid SERVER_SCIELO value: use a hostname or IP address, optionally followed by a port" >&2
  exit 1
fi
STANDARD_LANG_FILE_VALUE="$(read_def_value STANDARD_LANG)"
STANDARD_LANG_VALUE="${STANDARD_LANG:-$STANDARD_LANG_FILE_VALUE}"
STANDARD_LANG_VALUE="${STANDARD_LANG_VALUE:-en}"
if [[ ! "$STANDARD_LANG_VALUE" =~ ^[a-z]{2,3}$ ]]; then
  echo "Invalid STANDARD_LANG value: use a two- or three-letter lowercase language code" >&2
  exit 1
fi
ACTIVATE_GOOGLE_FILE_VALUE="$(read_def_value ACTIVATE_GOOGLE)"
ACTIVATE_GOOGLE_VALUE="${ACTIVATE_GOOGLE:-$ACTIVATE_GOOGLE_FILE_VALUE}"
ACTIVATE_GOOGLE_VALUE="${ACTIVATE_GOOGLE_VALUE:-0}"
if [[ ! "$ACTIVATE_GOOGLE_VALUE" =~ ^[01]$ ]]; then
  echo "Invalid ACTIVATE_GOOGLE value: use 0 or 1" >&2
  exit 1
fi
GOOGLE_CODE_FILE_VALUE="$(read_def_value GOOGLE_CODE)"
GOOGLE_CODE_VALUE="${GOOGLE_CODE:-$GOOGLE_CODE_FILE_VALUE}"
if [[ ! "$GOOGLE_CODE_VALUE" =~ ^[A-Za-z0-9_-]*$ ]]; then
  echo "Invalid GOOGLE_CODE value: use only letters, numbers, hyphens, or underscores" >&2
  exit 1
fi
if [[ "$ACTIVATE_GOOGLE_VALUE" == "1" && -z "$GOOGLE_CODE_VALUE" ]]; then
  echo "GOOGLE_CODE must be set when ACTIVATE_GOOGLE=1" >&2
  exit 1
fi
if [[ -n "${SERVER_SCIELO:-}" || -z "$SERVER_SCIELO_FILE_VALUE" ]]; then
  write_def_value SERVER_SCIELO "$SERVER_SCIELO_VALUE" SCIELO
fi
if [[ -n "${STANDARD_LANG:-}" || -z "$STANDARD_LANG_FILE_VALUE" ]]; then
  write_def_value STANDARD_LANG "$STANDARD_LANG_VALUE" SITE_INFO
fi
if [[ -n "${ACTIVATE_GOOGLE:-}" || -z "$ACTIVATE_GOOGLE_FILE_VALUE" ]]; then
  write_def_value ACTIVATE_GOOGLE "$ACTIVATE_GOOGLE_VALUE" LOG
fi
if [[ -n "${GOOGLE_CODE:-}" || -z "$GOOGLE_CODE_FILE_VALUE" ]]; then
  write_def_value GOOGLE_CODE "$GOOGLE_CODE_VALUE" LOG
fi

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

case "${SCIELO_INSTANCE_MIGRATION:-}" in
  check)
    /usr/local/bin/scielo-instance-check.sh --root /var/www/html --check || true
    ;;
  fix)
    /usr/local/bin/scielo-instance-check.sh --root /var/www/html --fix || true
    ;;
  "")
    ;;
  *)
    echo "Unsupported SCIELO_INSTANCE_MIGRATION value: ${SCIELO_INSTANCE_MIGRATION}" >&2
    echo "Use one of: check, fix" >&2
    ;;
esac

php-fpm -D
exec /usr/sbin/httpd -D FOREGROUND
