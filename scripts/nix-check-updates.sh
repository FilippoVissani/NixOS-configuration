#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nvd

nix-channel --update
nixos-rebuild build
nvd diff /run/current-system ./result
