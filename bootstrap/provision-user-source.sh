source_into_zshrc() {
  local target="$1"

  cat >> ~/.zshrc <<EOF

# Load $target if present; ignore if missing (e.g. first run before provisioning completes)
if [ -f "$target" ]; then
  source "$target"
else
  echo "INFO: $target not found; skipping setup."
fi
EOF
}
