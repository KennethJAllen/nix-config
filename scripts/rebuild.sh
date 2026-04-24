#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
exec nixos-rebuild switch \
  --flake .#mini-s12 \
  --target-host kallen@mini-s12 \
  --sudo \
  --ask-sudo-password
