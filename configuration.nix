{ config, pkgs, ... }:
let
  unstable-os = import <nixos-unstable> { };
  unstable-pkgs = import <nixpkgs-unstable> { };

  # Import comma with local nix-index preferred over the comma one.
  comma = import (builtins.fetchTarball
    "https://github.com/Shopify/comma/archive/60a4cf8ec5c93104d3cfb9fc5a5bac8fb18cc8e4.tar.gz") {
      inherit pkgs;
    };

in {
  imports = [
    <nixos-hardware/common/pc/ssd>
    <nixos-hardware/common/cpu/intel>
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Service configuration.
    ./containers.nix
    # ./prometheus.nix
  ];

  hardware = {
    opengl = {
      enable = true;
      extraPackages = [ pkgs.intel-compute-runtime ];
    };
    cpu.intel.updateMicrocode = true;
  };

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Linux kernel 5.10 LTS
    kernelPackages = unstable-os.linuxPackages_5_10;

    cleanTmpDir = true;
  };

  networking = {
    hostName = "servnerr";

    wireless.enable = false;
    firewall.enable = false;

    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSWf+pMgyV7gCuYvYh0ySizmKLhCCZCRw4trVqLeqol"
    ];
  };

  nix = {
    # Automatic Nix GC.
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      min-free = ${toString (500 * 1024 * 1024)}
    '';

    # Automatic store optimization.
    autoOptimiseStore = true;
  };

  system = {
    # Automatic upgrades.
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;

    stateVersion = "20.09";
  };

  environment = {
    # Put ~/bin in PATH.
    homeBinInPath = true;

    # Packages which should be installed on every machine.
    systemPackages = with pkgs; [
      bandwhich
      byobu
      comma
      dmidecode
      ethtool
      gcc
      go
      git
      unstable-pkgs.gitAndTools.gh
      gnumake
      htop
      iftop
      iperf3
      jq
      lm_sensors
      lshw
      lsscsi
      mosh
      mkpasswd
      mtr
      ndisc6
      neofetch
      nethogs
      nixfmt
      nmap
      nmon
      pciutils
      pkg-config
      unstable-pkgs.ripgrep
      smartmontools
      unstable-pkgs.tailscale
      tcpdump
      tmux
      unixtools.xxd
      unzip
      usbutils
      wget
      zsh
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.mosh.enable = true;

  # Enable Tailscale.
  services.tailscale.enable = true;

  # Run node_exporter everywhere.
  services.prometheus.exporters.node.enable = true;

  security.sudo.wheelNeedsPassword = false;
  virtualisation.podman = { enable = true; };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableGlobalCompInit = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "agnoster";
    };
  };
}
