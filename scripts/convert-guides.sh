#!/bin/bash
set -e

INPUT_DIR="docs/guides"
OUTPUT_BASE="docs/guides"
THEME="style/dracula.theme"
CSS="style/style.css"
EXTENSIONS=("docx" "pdf")

if command -v xelatex &>/dev/null; then
  PDF_ENGINE="xelatex"
elif command -v lualatex &>/dev/null; then
  PDF_ENGINE="lualatex"
else
  PDF_ENGINE="pdflatex"
fi
echo "🧩 Usando motor LaTeX: $PDF_ENGINE"

if fc-list | grep -qi "Inter"; then
  MAIN_FONT="Inter"
elif fc-list | grep -qi "IBM Plex Sans"; then
  MAIN_FONT="IBM Plex Sans"
else
  MAIN_FONT="Helvetica"
fi

if fc-list | grep -qi "JetBrains Mono"; then
  MONO_FONT="JetBrains Mono"
elif fc-list | grep -qi "Fira Code"; then
  MONO_FONT="Fira Code"
else
  MONO_FONT="Courier New"
fi

echo "🖋️  Fuente principal: $MAIN_FONT"
echo "💻 Fuente monoespaciada: $MONO_FONT"

for ext in "${EXTENSIONS[@]}"; do
  OUTPUT_DIR="$OUTPUT_BASE/$ext"
  mkdir -p "$OUTPUT_DIR"
done

for file in "$INPUT_DIR"/*.md; do
  filename=$(basename "$file" .md)
  echo "Convirtiendo $filename.md → ${EXTENSIONS[*]} ..."

  for ext in "${EXTENSIONS[@]}"; do
    if [[ "$ext" == "pdf" ]]; then
      pandoc "$file" \
        -o "$OUTPUT_BASE/$ext/$filename.$ext" \
        --highlight-style="$THEME" \
        --pdf-engine="$PDF_ENGINE" \
        -V mainfont="$MAIN_FONT" \
        -V monofont="$MONO_FONT" \
        -V fontsize=11pt \
        -V geometry:margin=2.5cm
    else
      pandoc "$file" \
        -o "$OUTPUT_BASE/$ext/$filename.$ext" \
        --highlight-style="$THEME" \
        --css="$CSS"
    fi
  done
done

echo "✅ Conversión completa. Archivos generados en subcarpetas de $OUTPUT_BASE/"
