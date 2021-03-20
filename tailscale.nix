{ config, lib, pkgs, ... }:

let

  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };

in {

  imports =
    [ <nixos-unstable/nixos/modules/services/networking/tailscale.nix> ];
  disabledModules = [ "services/networking/tailscale.nix" ];

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: { tailscale = unstable.tailscale; };
  };

  services.tailscale.enable = true;

}
