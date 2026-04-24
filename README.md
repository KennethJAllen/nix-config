# nix-config

NixOS config for `mini-s12`.

## Deploy
`./scripts/rebuild.sh`

## Update nixpkgs
`nix flake update && ./scripts/rebuild.sh`

## Bootstrap
On a fresh install, copy `hardware-configuration.nix` from the new host into this repo 
and run `./rebuild.sh` from a machine with `nixos-rebuild` + flakes.
