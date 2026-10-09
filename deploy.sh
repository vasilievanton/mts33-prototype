#!/bin/bash
# Сборка сайта в docs/: актуальная версия всегда на одном адресе (index.html),
# старые адреса с номером версии перенаправляют на него.
set -e
cd "$(dirname "$0")"
latest=$(ls MTS33_prototip_TZ_v*.html | sort -V | tail -1)
mkdir -p docs
# Локальные аудиозадания первого задания АПОЖ.
mkdir -p docs/assets/apozh
cp assets/apozh/*.wav docs/assets/apozh/
sed 's|<head>|<head>\n<meta name="robots" content="noindex">|' "$latest" > docs/index.html
for v in 0.2 0.3 0.4 $(ls MTS33_prototip_TZ_v*.html | sed -E 's/.*_v([0-9.]+)\.html/\1/'); do
  cat > "docs/MTS33_prototip_TZ_v$v.html" <<HTML
<!doctype html><html lang="ru"><head><meta charset="utf-8"><meta name="robots" content="noindex">
<script>location.replace('./' + location.hash);</script></head><body><a href="./">Открыть прототип и ТЗ</a></body></html>
HTML
done
node build_md.js "$latest" MTS33_opisanie_proekta.md
echo "docs/index.html <- $latest"
