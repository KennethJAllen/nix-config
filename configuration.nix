{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mini-s12";
  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.ipv4.addresses = [{
    address = "10.0.0.99";
    prefixLength = 24;
  }];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.firewall.allowedTCPPorts = [ 22 ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.kallen = {
    isNormalUser = true;
    description = "Kenneth Allen";
    extraGroups = [ "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim wget curl tmux htop iotop lsof
    git
    jq ripgrep fd ncdu duf bat
    mtr nmap dnsutils
    nix-tree nvd
    (python3.withPackages (ps: with ps; [
      pip requests numpy pandas
    ]))
    claude-code
  ];

  programs.bash = {
    completion.enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake github:KennethJAllen/nix-config#mini-s12";
    };
    interactiveShellInit = ''
      HISTSIZE=10000
      HISTFILESIZE=20000
      HISTCONTROL=ignoredups:erasedups
      shopt -s histappend
    '';
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.mosh.enable = true;
  programs.mtr.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  services.journald.extraConfig = "SystemMaxUse=2G";

  swapDevices = [{ device = "/swapfile"; size = 8192; }];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "kallen" ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:KennethJAllen/nix-config#mini-s12";
    allowReboot = false;
  };

  system.stateVersion = "25.11";
}
