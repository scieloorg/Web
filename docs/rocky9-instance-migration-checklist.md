# Rocky9/PHP 8 SciELO instance checklist

Use this checklist for each legacy SciELO Web instance mounted into the Rocky9/PHP 8 image.

## What must be validated

1. The instance root is mounted at the path expected by the image, usually `/var/www/html`.
2. CGI and CISIS binaries are compatible with the image architecture:
   - `cgi-bin/wxis.exe`
   - `cgi-bin/iah/auxs/wxis.exe`
   - `cgi-bin/temp/wxis`
   - `proc/cisis/mx`
   - `proc/cisis/mxcp`
   - `proc/cisis/ifkeys`
3. Definition files exist and point to the local WXIS endpoint:
   - `htdocs/scielo.def.php`
   - `htdocs/iah/iah.def`
   - `htdocs/iah/title.def`
   - `htdocs/iah/article.def`
4. Legacy ISIS inverted indexes (`*.iy0`) are not active for databases used by WXIS.
5. Core databases have modern inverted index files (`.cnt`, `.iyp`, `.ly1`, `.ly2`, `.n01`, `.n02`):
   - `bases/title/title`
   - `bases/title/logo`
   - `bases/newissue/newissue`
   - `bases/artigo/artigo`
   - `bases/issue/issue`
   - `bases/issue/facic`
   - `bases/issue/faccount`
   - `bases/cited/cited`
   - `bases/related/related`
   - `bases/iah/*/search`
   - `bases/iah/*/searchp`
6. Smoke URLs return HTTP 200:
   - `/scielo.php`
   - `/scielo.php?script=sci_serial&pid=<journal>&nrm=iso`
   - `/scielo.php?script=sci_arttext&pid=<article>&lng=en&nrm=iso&tlng=pt`
   - `/oai/scielo-oai.php?verb=Identify`

## Manual check

Inside the container:

```sh
scielo-instance-check.sh --root /var/www/html --check \
  --base-url http://127.0.0.1 \
  --journal 1519-7654 \
  --pid S1519-76542014000100001
```

From the host, using Docker Compose:

```sh
docker compose exec -T scielo-web scielo-instance-check.sh --root /var/www/html --check \
  --base-url http://127.0.0.1 \
  --journal 1519-7654 \
  --pid S1519-76542014000100001
```

## Automatic repair

Run this only after confirming the mounted directory is the instance you want to repair:

```sh
docker compose exec -T scielo-web scielo-instance-check.sh --root /var/www/html --fix
```

The repair mode rebuilds known ISIS indexes and moves active `.iy0` files to timestamped backups such as `title.iy0.bak.YYYYMMDDHHMMSS`.

## Optional container startup mode

The Rocky9 image supports an optional environment variable:

```yaml
environment:
  SCIELO_INSTANCE_MIGRATION: check
```

Allowed values:

- `check`: validate the mounted instance and print warnings during container startup.
- `fix`: rebuild known indexes during container startup.

Keep the default empty value for production unless you explicitly want startup validation or repair.

## Notes

- The image can be healthy while a mounted legacy instance is not. Treat each instance as data that needs a compatibility pass.
- The most common failure after moving to Rocky9/PHP 8 is `WXIS|fatal error|unavoidable|leafread/ock|`, usually caused by legacy `.iy0` files.
- Rebuilding indexes does not rewrite `.mst` or `.xrf` data files.
