#!/usr/bin/env bash
set -euo pipefail

# Convert all Markdown files under docs/guides to PDF into docs/pdf
# Priority (auto): Docker+Pandoc > local pandoc > npx md-to-pdf
# Override backend with env var: PDF_BACKEND=pandoc|node

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT_DIR="$ROOT_DIR/docs/guides"
OUTPUT_DIR="$ROOT_DIR/docs/pdf"
mkdir -p "$OUTPUT_DIR"

# Styles (customize via env)
# Prefer PANDOC_SYNTAX_STYLE; fallback to PANDOC_HIGHLIGHT_STYLE; default tango
PANDOC_SYNTAX_STYLE="${PANDOC_SYNTAX_STYLE:-${PANDOC_HIGHLIGHT_STYLE:-tango}}"
PANDOC_MAINFONT="${PANDOC_MAINFONT:-}"                 # e.g., "TeX Gyre Termes" (para símbolos como ≤)
PANDOC_MONOFONT="${PANDOC_MONOFONT:-}"                # e.g., "TeX Gyre Cursor" o "Fira Code"
MD_TO_PDF_CONFIG="$INPUT_DIR/md-to-pdf.config.json"

has_cmd() { command -v "$1" >/dev/null 2>&1; }

supports_syntax_highlighting_flag() {
  # $1 = method: docker-pandoc|pandoc
  if [[ "$1" == "docker-pandoc" ]]; then
    docker run --rm pandoc/latex:latest pandoc --help 2>/dev/null | grep -q "--syntax-highlighting" || return 1
  else
    pandoc --help 2>/dev/null | grep -q "--syntax-highlighting" || return 1
  fi
}

build_pandoc_args() {
  # $1 = method: docker-pandoc|pandoc
  local args=()
  if supports_syntax_highlighting_flag "$1"; then
    args+=("--syntax-highlighting=$PANDOC_SYNTAX_STYLE")
  else
    # Backward compat for older pandoc
    args+=("--highlight-style=$PANDOC_SYNTAX_STYLE")
  fi
  # Fonts
  [[ -n "$PANDOC_MAINFONT" ]] && args+=( -V "mainfont=$PANDOC_MAINFONT" )
  [[ -n "$PANDOC_MONOFONT" ]] && args+=( -V "monofont=$PANDOC_MONOFONT" )
  printf '%s\n' "${args[@]}"
}

convert_with_docker_pandoc() {
  local md="$1"; local outpdf="$2"
  # shellcheck disable=SC2207
  local style_args=( $(build_pandoc_args docker-pandoc) )
  docker run --rm -v "$ROOT_DIR":"/data" pandoc/latex:latest \
    --from=gfm --pdf-engine=xelatex \
    "${style_args[@]}" \
    "/data/docs/guides/$(basename "$md")" -o "/data/docs/pdf/$(basename "$outpdf")"
}

convert_with_pandoc() {
  local md="$1"; local outpdf="$2"
  # shellcheck disable=SC2207
  local style_args=( $(build_pandoc_args pandoc) )
  pandoc --from=gfm --pdf-engine=xelatex \
    "${style_args[@]}" \
    "$md" -o "$outpdf"
}

convert_with_md_to_pdf() {
  local md="$1"; local outpdf="$2"
  if [[ ! -f "$MD_TO_PDF_CONFIG" ]]; then
    echo "No se encontró $MD_TO_PDF_CONFIG. Crea la config antes de continuar." >&2
    exit 3
  fi
  npx -y md-to-pdf "$md" --config-file "$MD_TO_PDF_CONFIG" --out "$outpdf"
}

choose_method() {
  local preferred="${PDF_BACKEND:-}"
  if [[ "$preferred" == "pandoc" ]]; then
    if has_cmd docker; then echo "docker-pandoc"; return; fi
    if has_cmd pandoc;  then echo "pandoc"; return;  fi
    echo "node"; return
  elif [[ "$preferred" == "node" ]]; then
    echo "node"; return
  fi
  if has_cmd docker; then echo "docker-pandoc"; return; fi
  if has_cmd pandoc;  then echo "pandoc"; return;  fi
  if has_cmd npx;     then echo "node"; return;    fi
  echo ""
}

main() {
  shopt -s nullglob
  local files=("$INPUT_DIR"/*.md)
  if [ ${#files[@]} -eq 0 ]; then
    echo "No se encontraron archivos .md en $INPUT_DIR" >&2
    exit 1
  fi

  echo "Generando PDFs en: $OUTPUT_DIR"
  local method
  method="$(choose_method || true)"
  if [[ -z "$method" ]]; then
    echo "No se encontró Docker, pandoc ni npx. Opciones:" >&2
    echo "- Instala Docker y vuelve a ejecutar el script." >&2
    echo "- O instala pandoc (+ LaTeX) y ejecuta de nuevo." >&2
    echo "- O instala Node.js (npx) para usar md-to-pdf." >&2
    exit 2
  fi

  for f in "${files[@]}"; do
    base="$(basename "$f" .md)"
    out="$OUTPUT_DIR/$base.pdf"
    case "$method" in
      docker-pandoc) convert_with_docker_pandoc "$f" "$out" ;;
      pandoc)        convert_with_pandoc        "$f" "$out" ;;
      node)          convert_with_md_to_pdf     "$f" "$out" ;;
    esac
    echo "✓ $base.pdf"
  done
  echo "Listo. PDFs en $OUTPUT_DIR (backend: $method)"
}

main "$@"
