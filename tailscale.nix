{ config, lib, pkgs, modulesPath, ... }:

{

  imports =
    [ <nixos-unstable/nixos/modules/services/networking/tailscale.nix> ];
  disabledModules = [ "services/networking/tailscale.nix" ];

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: { tailscale = unstable.tailscale; };
  };

  services.tailscale.enable = true;

}
