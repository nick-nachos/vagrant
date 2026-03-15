#!/usr/bin/env zsh
# Utility functions for working with PDFs in this repo

pdf_strip_pass() {
  local pdf_path=""
  local password=""
  local out_path=""

  # Parse optional flag(s) (allow -o anywhere).
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        cat <<'EOF'
Usage: pdf_strip_pass <pdf-path> <password> [-o output-path]

Removes password protection from a PDF using qpdf.

By default, this writes the unlocked PDF next to the input file with a
".nopass.pdf" suffix (e.g. input.pdf -> input.nopass.pdf).

Arguments:
  pdf-path      Path to the existing (password-protected) PDF.
  password      Password used to unlock the PDF.

Options:
  -o <path>     Write output to the given file path.
  -h, --help    Show this help message and exit.
EOF
        return 0
        ;;
      -o)
        shift
        out_path="$1"
        ;;
      -* )
        echo "Unknown option: $1" >&2
        return 1
        ;;
      *)
        if [[ -z "$pdf_path" ]]; then
          pdf_path="$1"
        elif [[ -z "$password" ]]; then
          password="$1"
        else
          echo "Unexpected argument: $1" >&2
          return 1
        fi
        ;;
    esac
    shift
  done

  if [[ -z "$pdf_path" || -z "$password" ]]; then
    echo "Usage: pdf_strip_pass <pdf-path> <password> [-o output-path]" >&2
    return 1
  fi

  if [[ ! -f "$pdf_path" ]]; then
    echo "Error: file does not exist: $pdf_path" >&2
    return 1
  fi

  if ! command -v qpdf >/dev/null 2>&1; then
    echo "Error: qpdf is not installed or not on PATH" >&2
    return 1
  fi

  local dir
  local base
  local out

  if [[ -n "$out_path" ]]; then
    # Ensure the target directory exists before trying to write.
    if [[ ! -d $(dirname -- "$out_path") ]]; then
      echo "Error: output directory does not exist: $(dirname -- \"$out_path\")" >&2
      return 1
    fi

    out="$out_path"
  else
    dir=$(dirname -- "$pdf_path")
    base=$(basename -- "$pdf_path" .pdf)
    out="$dir/${base}.nopass.pdf"
  fi

  qpdf --password="$password" --decrypt "$pdf_path" "$out"
}

pdf_strip_pass_all() {
  local pdf_dir=""
  local password=""
  local out_dir=""

  # Parse optional flag(s) (allow -o anywhere).
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        cat <<'EOF'
Usage: pdf_strip_pass_all <pdf-dir> <password> [-o output-dir]

Applies pdf_strip_pass to every .pdf file in the given directory.

By default, output files are written next to their source PDFs using the
".nopass.pdf" suffix. If -o is provided:
  - Relative paths are treated as a subdirectory of <pdf-dir> (and created).
  - Absolute paths must already exist.

Arguments:
  pdf-dir       Directory containing PDF files.
  password      Password used to unlock each PDF.

Options:
  -o <dir>      Write output files into this directory (created if needed).
  -h, --help    Show this help message and exit.
EOF
        return 0
        ;;
      -o)
        shift
        out_dir="$1"
        ;;
      -* )
        echo "Unknown option: $1" >&2
        return 1
        ;;
      *)
        if [[ -z "$pdf_dir" ]]; then
          pdf_dir="$1"
        elif [[ -z "$password" ]]; then
          password="$1"
        else
          echo "Unexpected argument: $1" >&2
          return 1
        fi
        ;;
    esac
    shift
  done

  if [[ -z "$pdf_dir" || -z "$password" ]]; then
    echo "Usage: pdf_strip_pass_all <pdf-dir> <password> [-o output-dir]" >&2
    return 1
  fi

  if [[ ! -d "$pdf_dir" ]]; then
    echo "Error: directory does not exist: $pdf_dir" >&2
    return 1
  fi

  if [[ -n "$out_dir" ]]; then
    if [[ "$out_dir" != /* ]]; then
      # Relative path: resolve as a subdir of pdf_dir and create it.
      out_dir="$pdf_dir/$out_dir"
      mkdir -p -- "$out_dir"
    elif [[ ! -d "$out_dir" ]]; then
      echo "Error: output directory does not exist: $out_dir" >&2
      return 1
    fi
  fi

  # Allow for spaces in filenames and ensure the loop skips when no matches.
  # In zsh this is `setopt nullglob`.
  if [[ -n "$ZSH_VERSION" ]]; then
    setopt nullglob
  else
    shopt -s nullglob 2>/dev/null || true
  fi

  local file
  local count=0

  for file in "$pdf_dir"/*.pdf; do
    # If the glob didn't match, nullglob makes the loop skip automatically.
    if [[ -f "$file" ]]; then
      # Skip files that are already the "-nopass" output.
      if [[ "$file" == *.nopass.pdf ]]; then
        continue
      fi

      if [[ -n "$out_dir" ]]; then
        pdf_strip_pass "$file" "$password" -o "$out_dir/$(basename -- "$file")"
      else
        pdf_strip_pass "$file" "$password"
      fi
      ((count++))
    fi
  done

  if [[ $count -eq 0 ]]; then
    echo "No PDF files found in: $pdf_dir" >&2
    return 1
  fi

  return 0
}
