{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable-small> { };

in {
    imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    boot = {
      # Use the systemd-boot EFI boot loader.
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # Linux kernel 5.10 LTS
      kernelPackages = unstable.linuxPackages_5_10;
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
      extraGroups = [ "wheel" "sudo" ]; # Enable ‘sudo’ for the user.

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
        dmidecode
        ethtool
        gcc
        go
        git
        gnumake
        htop
        iftop
        iperf3
        jq
        lm_sensors
        lshw
        lsscsi
        mkpasswd
        mtr
        ndisc6
        neofetch
        nethogs
        nixfmt
        nix-linter
        nmap
        nmon
        pciutils
        pkg-config
        smartmontools
        tcpdump
        tmux
        unixtools.xxd
        unzip
        usbutils
        wget
      ];
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable the Tailscale.
    services.tailscale.enable = true;
}
