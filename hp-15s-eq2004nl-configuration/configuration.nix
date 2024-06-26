# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''options hid_apple fnmode=0'';

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.libvirtd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.fwupd.enable = true;
  

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable restic for backups
  services.restic.backups = {
    remotebackup = {
      user = "filippo";
      passwordFile = "/etc/nixos/secrets/restic-password";
      paths = [
        "/home/filippo/.config"
        "/home/filippo/Documents"
        "/home/filippo/Pictures"
        "/home/filippo/.zsh_history"
        "/home/filippo/zshrc"
        "/home/filippo/.gitconfig"
      ];
      repository = "sftp:filippo@192.168.1.101:/mnt/volume1/VOLUME1/restic-repo";
      timerConfig = {
        OnCalendar = "13:00";
        Persistent = true;
      };
      pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
      ];
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  users.users.filippo = {
    isNormalUser = true;
    description = "Filippo Vissani";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };
  home-manager.users.filippo = { pkgs, ... }: {
    home.stateVersion = "24.05";
    home.packages = [  ];
    programs.zsh = {
      enable = true;
      initExtra = ''
        . ~/zshrc
      '';
    };
  };  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    neovim
    helix
    spotify
    google-chrome
    neofetch
    bitwarden
    libsForQt5.plasma-vault
    jetbrains.idea-ultimate
    nodejs_20
    vscode
    unzip
    zip
    git
    gnupg
    htop
    gcc
    clang
    jdk17
    gradle
    sbt
    dotty
    graphviz
    rustup
    firefox
    kate
    thunderbird
    texlive.combined.scheme-full
    gh
    telegram-desktop
    drawio
    toybox
    wayland-utils
    dmidecode
    gimp-with-plugins
    glava
    ruby
    darkman
    geoclue2
    qbittorrent
    obs-studio
    vlc
    libsForQt5.kdenlive
    restic
    virt-manager
    libreoffice-qt
    hunspell
    hunspellDicts.it_IT
    calibre
    partition-manager
    libsForQt5.filelight
    kodi-wayland
    inkscape
    batik
    chromium
    retroarchFull
  ];

  environment.shells = with pkgs; [ zsh ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.gnupg.agent = {                                                      
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Enable cron service

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # Automated garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
