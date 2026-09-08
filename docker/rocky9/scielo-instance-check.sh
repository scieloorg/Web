#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scielo-instance-check.sh [--root /var/www/html] [--check|--fix] [--base-url URL]

Modes:
  --check  Validate binaries, configuration, legacy ISIS indexes and smoke URLs.
  --fix    Rebuild known ISIS indexes and keep legacy .iy0 files as timestamped backups.

Options:
  --root       SciELO instance root. Default: /var/www/html
  --base-url   Optional HTTP base URL for smoke checks. Example: http://127.0.0.1
  --pid        Optional article PID for sci_arttext smoke check.
  --journal    Optional journal ISSN/PID for sci_serial smoke check.
USAGE
}

ROOT="/var/www/html"
MODE="check"
BASE_URL=""
ARTICLE_PID=""
JOURNAL_PID=""
STATUS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      ROOT="${2:-}"
      shift 2
      ;;
    --check)
      MODE="check"
      shift
      ;;
    --fix)
      MODE="fix"
      shift
      ;;
    --base-url)
      BASE_URL="${2:-}"
      shift 2
      ;;
    --pid)
      ARTICLE_PID="${2:-}"
      shift 2
      ;;
    --journal)
      JOURNAL_PID="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

ROOT="${ROOT%/}"
MX="$ROOT/proc/cisis/mx"
STAMP="$(date +%Y%m%d%H%M%S)"
TMPDIR="${TMPDIR:-/tmp}/scielo-instance-check.$$"

ok() {
  echo "OK    $*"
}

warn() {
  echo "WARN  $*"
  STATUS=1
}

fail() {
  echo "FAIL  $*"
  STATUS=1
}

section() {
  echo
  echo "== $* =="
}

cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

require_root() {
  if [[ ! -d "$ROOT" ]]; then
    fail "instance root not found: $ROOT"
    exit 1
  fi
}

check_exec() {
  local path="$1"
  local label="$2"
  if [[ ! -f "$path" ]]; then
    fail "$label missing: $path"
    return
  fi
  if [[ ! -x "$path" ]]; then
    if [[ "$MODE" == "fix" ]]; then
      chmod +x "$path"
      ok "$label executable bit enabled: $path"
    else
      warn "$label is not executable: $path"
    fi
  else
    ok "$label exists and is executable: $path"
  fi
}

check_wxis() {
  local path="$1"
  local label="$2"
  check_exec "$path" "$label"
  [[ -x "$path" ]] || return 0

  local output
  output="$("$path" 2>&1 || true)"
  if grep -q "WXIS|missing error|parameter|IsisScript" <<<"$output"; then
    ok "$label responds as WXIS"
  else
    warn "$label did not return the expected WXIS probe output"
  fi
}

check_def_files() {
  section "Definition files"
  local files=(
    "$ROOT/htdocs/scielo.def.php"
    "$ROOT/htdocs/iah/iah.def"
    "$ROOT/htdocs/iah/title.def"
    "$ROOT/htdocs/iah/article.def"
  )

  local file
  for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
      ok "found $file"
    else
      warn "missing $file"
    fi
  done

  if [[ -f "$ROOT/htdocs/scielo.def.php" ]]; then
    local server_scielo
    server_scielo="$(LC_ALL=C sed -n 's/^SERVER_SCIELO=//p' "$ROOT/htdocs/scielo.def.php" | head -n 1)"
    if [[ -n "$server_scielo" ]]; then
      ok "SERVER_SCIELO points to $server_scielo"
    else
      warn "SERVER_SCIELO is missing or empty"
    fi

    local standard_lang
    standard_lang="$(LC_ALL=C sed -n 's/^STANDARD_LANG=//p' "$ROOT/htdocs/scielo.def.php" | head -n 1)"
    if [[ "$standard_lang" =~ ^[a-z]{2,3}$ ]]; then
      ok "STANDARD_LANG is set to $standard_lang"
    else
      warn "STANDARD_LANG is missing or invalid"
    fi

    local activate_google google_code
    activate_google="$(LC_ALL=C sed -n 's/^ACTIVATE_GOOGLE=//p' "$ROOT/htdocs/scielo.def.php" | head -n 1)"
    google_code="$(LC_ALL=C sed -n 's/^GOOGLE_CODE=//p' "$ROOT/htdocs/scielo.def.php" | head -n 1)"
    if [[ "$activate_google" == "0" ]]; then
      ok "Google Analytics is disabled"
    elif [[ "$activate_google" == "1" && -n "$google_code" ]]; then
      ok "Google Analytics is enabled"
    else
      warn "Google Analytics configuration is incomplete or invalid"
    fi
  fi
}

check_binaries() {
  section "Binaries"
  check_exec "$MX" "CISIS mx"
  check_exec "$ROOT/proc/cisis/mxcp" "CISIS mxcp"
  check_exec "$ROOT/proc/cisis/ifkeys" "CISIS ifkeys"
  check_wxis "$ROOT/cgi-bin/wxis.exe" "CGI WXIS"
  check_wxis "$ROOT/cgi-bin/iah/auxs/wxis.exe" "IAH aux WXIS"
  check_wxis "$ROOT/cgi-bin/temp/wxis" "temporary WXIS"
}

has_database() {
  local db="$1"
  [[ -f "$db.mst" && -f "$db.xrf" ]]
}

backup_iy0() {
  local db="$1"
  if [[ -f "$db.iy0" ]]; then
    mv "$db.iy0" "$db.iy0.bak.$STAMP"
    ok "backed up legacy index: $db.iy0.bak.$STAMP"
  fi
}

apply_index() {
  local tmpbase="$1"
  local db="$2"
  local ext
  for ext in cnt iyp ly1 ly2 n01 n02; do
    if [[ -f "$tmpbase.$ext" ]]; then
      cp "$tmpbase.$ext" "$db.$ext"
    fi
  done
  backup_iy0 "$db"
}

reindex_with_fst() {
  local db="$1"
  local fst="$2"
  local label="$3"
  local safe_label
  safe_label="$(sed 's#[^A-Za-z0-9_.-]#_#g' <<<"$label")"
  local tmpbase="$TMPDIR/$safe_label"

  if ! has_database "$db"; then
    warn "$label skipped; database files missing: $db.mst/.xrf"
    return
  fi
  if [[ ! -f "$fst" ]]; then
    warn "$label skipped; FST missing: $fst"
    return
  fi

  if [[ "$MODE" == "fix" ]]; then
    mkdir -p "$TMPDIR"
    "$MX" "$db" "fst=@$fst" "fullinv=$tmpbase" -all now >/dev/null
    apply_index "$tmpbase" "$db"
    ok "$label reindexed from $fst"
  else
    if [[ -f "$db.iy0" ]]; then
      warn "$label has legacy .iy0 index: $db.iy0"
    else
      ok "$label has modern index files or no legacy .iy0"
    fi
  fi
}

reindex_pid880() {
  local db="$1"
  local label="$2"
  local tmpfst="$TMPDIR/pid880.fst"
  local safe_label
  safe_label="$(sed 's#[^A-Za-z0-9_.-]#_#g' <<<"$label")"
  local tmpbase="$TMPDIR/$safe_label"

  if ! has_database "$db"; then
    warn "$label skipped; database files missing: $db.mst/.xrf"
    return
  fi

  if [[ "$MODE" == "fix" ]]; then
    mkdir -p "$TMPDIR"
    printf '880 0 v880\n' > "$tmpfst"
    "$MX" "$db" "fst=@$tmpfst" "fullinv=$tmpbase" -all now >/dev/null
    apply_index "$tmpbase" "$db"
    ok "$label reindexed by PID field 880"
  else
    if [[ -f "$db.iy0" ]]; then
      warn "$label has legacy .iy0 index: $db.iy0"
    else
      ok "$label has modern index files or no legacy .iy0"
    fi
  fi
}

check_indexes() {
  section "ISIS indexes"
  if [[ ! -x "$MX" ]]; then
    fail "cannot check or rebuild indexes without executable mx: $MX"
    return
  fi

  reindex_with_fst "$ROOT/bases/title/title" "$ROOT/proc/fst/title.fst" "title"
  reindex_with_fst "$ROOT/bases/title/logo" "$ROOT/proc/fst/logo.fst" "logo"
  reindex_with_fst "$ROOT/bases/newissue/newissue" "$ROOT/proc/fst/newissue.fst" "newissue"
  reindex_with_fst "$ROOT/bases/artigo/artigo" "$ROOT/proc/fst/artigo.fst" "artigo"
  reindex_with_fst "$ROOT/bases/issue/issue" "$ROOT/proc/fst/issue.fst" "issue"
  reindex_with_fst "$ROOT/bases/issue/facic" "$ROOT/proc/fst/facic.fst" "facic"
  reindex_with_fst "$ROOT/bases/issue/faccount" "$ROOT/proc/fst/faccount.fst" "faccount"
  reindex_pid880 "$ROOT/bases/cited/cited" "cited"
  reindex_pid880 "$ROOT/bases/related/related" "related"

  local search_db
  while IFS= read -r search_db; do
    reindex_with_fst "${search_db%.mst}" "$ROOT/proc/fst/search.fst" "iah-search-${search_db%.mst}"
  done < <(find "$ROOT/bases/iah" -path '*/search.mst' -type f 2>/dev/null | sort)

  while IFS= read -r search_db; do
    reindex_with_fst "${search_db%.mst}" "$ROOT/proc/fst/searchp.fst" "iah-searchp-${search_db%.mst}"
  done < <(find "$ROOT/bases/iah" -path '*/searchp.mst' -type f 2>/dev/null | sort)
}

check_remaining_iy0() {
  section "Remaining legacy .iy0 files"
  local files
  files="$(find "$ROOT/bases" -name '*.iy0' -type f 2>/dev/null | sort || true)"
  if [[ -z "$files" ]]; then
    ok "no active .iy0 files found under $ROOT/bases"
  else
    warn "active .iy0 files remain; review whether they are used by WXIS"
    echo "$files"
  fi
}

smoke_url() {
  local label="$1"
  local url="$2"
  local code
  code="$(curl -o /dev/null -sS -w '%{http_code}' "$url" || true)"
  if [[ "$code" == "200" ]]; then
    ok "$label returned HTTP 200"
  else
    warn "$label returned HTTP $code: $url"
  fi
}

smoke_checks() {
  [[ -n "$BASE_URL" ]] || return
  section "HTTP smoke checks"
  smoke_url "home" "$BASE_URL/scielo.php"
  if [[ -n "$JOURNAL_PID" ]]; then
    smoke_url "sci_serial" "$BASE_URL/scielo.php?script=sci_serial&pid=$JOURNAL_PID&nrm=iso"
  fi
  if [[ -n "$ARTICLE_PID" ]]; then
    smoke_url "sci_arttext" "$BASE_URL/scielo.php?script=sci_arttext&pid=$ARTICLE_PID&lng=en&nrm=iso&tlng=pt"
  fi
  smoke_url "OAI Identify" "$BASE_URL/oai/scielo-oai.php?verb=Identify"
}

main() {
  require_root
  echo "SciELO Rocky9 instance ${MODE}"
  echo "Root: $ROOT"
  check_binaries
  check_def_files
  check_indexes
  check_remaining_iy0
  smoke_checks

  echo
  if [[ "$STATUS" -eq 0 ]]; then
    echo "Result: OK"
  else
    echo "Result: WARNINGS_OR_FAILURES"
  fi
  exit "$STATUS"
}

main "$@"
