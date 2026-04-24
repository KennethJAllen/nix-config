#!/usr/bin/env bash
set -euo pipefail

HOST="mini-s12"
REMOTE_DIR="/etc/nixos"
STAGING_DIR="/tmp/nixos-config-staging"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Syncing config to $HOST:$STAGING_DIR..."
ssh "$HOST" "mkdir -p $STAGING_DIR"
rsync -av --checksum \
  "$SCRIPT_DIR/configuration.nix" \
  "$SCRIPT_DIR/hardware-configuration.nix" \
  "$HOST:$STAGING_DIR/"

echo "Installing config and running nixos-rebuild on $HOST..."
ssh -t "$HOST" "sudo install -m 644 -o root -g root $STAGING_DIR/configuration.nix $STAGING_DIR/hardware-configuration.nix $REMOTE_DIR/ && sudo nixos-rebuild switch"

echo "Done."
