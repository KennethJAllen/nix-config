#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
exec nixos-rebuild switch \
  --flake .#spectra \
  --target-host kallen@spectra \
  --sudo \
  --ask-sudo-password
