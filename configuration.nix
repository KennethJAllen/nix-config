{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "spectra";
    useDHCP = false;
    interfaces.enp1s0.ipv4.addresses = [{
      address = "10.0.0.99";
      prefixLength = 24;
    }];
    defaultGateway = "10.0.0.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.kallen = {
    isNormalUser = true;
    description = "Kenneth Allen";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdhaFQk5eOjQOfCkCUNt2VsISiYyxlUk4MNG+uDBos1 kallen"
    ];
    # For a fresh install, set this so you can sudo on first boot:
    # hashedPassword = "$6$..."; # generate with: mkpasswd -m sha-512
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim wget curl tmux htop iotop lsof
    git
    jq ripgrep fd ncdu duf bat
    nmap dnsutils
    nix-tree nvd
    (python3.withPackages (ps: with ps; [
      requests numpy pandas
    ]))
    claude-code
  ];

  programs.bash = {
    completion.enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
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

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "kallen" ];
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:KennethJAllen/nix-config#spectra";
    allowReboot = false;
  };

  system.stateVersion = "25.11";
}
