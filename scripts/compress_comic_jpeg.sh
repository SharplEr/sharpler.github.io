#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/compress_comic_jpeg.sh <input_dir> [output_dir] [quality]

Arguments:
  input_dir   Directory with source images.
  output_dir  Directory for compressed JPEG files.
              Default: <input_dir>/compressed_jpeg
  quality     JPEG quality for ffmpeg qscale:v.
              Lower is better quality and larger files.
              Default: 4

Examples:
  scripts/compress_comic_jpeg.sh comix/project_delta/00
  scripts/compress_comic_jpeg.sh comix/project_delta/00 comix/project_delta/00/compressed 3
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 3 ]]; then
  usage >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required but not installed." >&2
  exit 1
fi

input_dir="${1%/}"
output_dir="${2:-$input_dir/compressed_jpeg}"
quality="${3:-4}"

if [[ ! -d "$input_dir" ]]; then
  echo "Input directory does not exist: $input_dir" >&2
  exit 1
fi

if ! [[ "$quality" =~ ^[0-9]+$ ]]; then
  echo "Quality must be a non-negative integer, got: $quality" >&2
  exit 1
fi

mkdir -p "$output_dir"

shopt -s nullglob

found_any=0

for src in "$input_dir"/*; do
  [[ -f "$src" ]] || continue

  case "${src##*.}" in
    jpg|JPG|jpeg|JPEG|png|PNG|webp|WEBP)
      ;;
    *)
      continue
      ;;
  esac

  found_any=1

  base_name="$(basename "$src")"
  stem="${base_name%.*}"
  dst="$output_dir/$stem.jpg"

  echo "Compressing $src -> $dst"

  ffmpeg -y \
    -i "$src" \
    -vf "scale=-2:1800:flags=lanczos" \
    -qscale:v "$quality" \
    -update 1 \
    -frames:v 1 \
    "$dst"
done

if [[ "$found_any" -eq 0 ]]; then
  echo "No supported image files found in: $input_dir" >&2
  exit 1
fi

echo "Done. Compressed files are in: $output_dir"
