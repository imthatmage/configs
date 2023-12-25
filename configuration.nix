# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.syncthing = {
      enable = true;
      user = "verreful";
      dataDir = "/home/verreful";    # Default folder for new synced folders
      configDir = "/home/verreful/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # tlp and powersave configuration

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "intel_pstate=disable"
    # Do not set iommu=off, because this will cause the SD-Card reader
    # driver to kernel panic.
    "iommu=soft"
  ];
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0=75;
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      CPU_SCALING_MIN_FREQ_ON_AC = 800000;
      CPU_SCALING_MAX_FREQ_ON_AC = 2600000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 2000000;
      # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      # A value of 0 disables, >=1 enables power saving (recommended: 1).
      # Default: 0 (AC), 1 (BAT)
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      # Runtime Power Management for PCI(e) bus devices: on = disable, auto=enable.
      # Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      # Battery feature drivers: 0 = disable, 1=enable
      # Default: 1 (all)
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.verreful = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # code
      (python310.withPackages(ps: with ps; [ pandas requests matplotlib scikit-learn numpy imageio scipy tqdm seaborn torch tifffile jupyterlab xmltodict openpyxl plotly scikit-image statsmodels]))
      openvpn
      gcc9
      cargo rustc rustup
      fish
      tmux
      git
      subversion
      vscode-fhs
      neovim
      nodejs_20
      tree
      nomacs
      zathura
      libreoffice
      newsboat
      urlscan
      w3m
      lynx
      lm_sensors
      ranger
      bat
      fzf
      tldr
      gotop
      neofetch

      telegram-desktop
      filezilla
      obsidian
      obs-studio
      mpv
      yt-dlp
      # data
      syncthing
      qbittorrent

      samba
      cifs-utils
    ];
  };

  # Allow swaylock to unlock the computer for us
  # security.pam.services.swaylock = {
  #   text = "auth include login";
  # };
  security.pam.services.swaylock = {};
  # if fprintd is enabled
  # security.pam.services.swaylock.fprintAuth = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.openssh = {
    enable = true;
    ports = [ 69 ];
    settings.PermitRootLogin = "no";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 69 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the defaultj
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # waybar
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
     })
    )
    home-manager
    firefox
    waybar
    dunst
    libnotify
    swww
    alacritty
    kitty
    wofi
    networkmanagerapplet
    hyprpicker
    acpi
    swaylock-effects

    unzip
    # screenshot utility
    grim 
    # select utility
    slurp 
    # xclip alternative
    wl-clipboard
    swappy

    htop-vim

    font-awesome
    librewolf
    wlr-randr
    xfce.thunar
    tlp
    imv
    brightnessctl
    pamixer
  ];
  # XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  #
  programs.nm-applet.enable = true;

  fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
    	(nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" ]; })
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        font-awesome
        source-han-sans
        open-sans
        source-han-sans-japanese
        source-han-serif-japanese
      ];
      # fontconfig.defaultFonts = {
      #   serif = [ "Noto Serif" "Source Han Serif" ];
      #   sansSerif = [ "Open Sans" "Source Han Sans" ];
      #   emoji = [ "Noto Color Emoji" ];
      # };
  };

  # thinkpad options
  systemd.services.thinkfan.preStart = "
    /run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi
  ";

  # must be same solution as above, but it does not work
  # boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  services.thinkfan = {
    # postconditions:
    # 1) status should be enabled:
    # cat /proc/acpi/ibm/fan
    # 2) No errors in systemd logs:
    # journalctl -u thinkfan.service -f

    enable = true;
    # preStart = "/run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi";

    # Entries here discovered by:
    # find /sys/devices -type f -name "temp*_input"
    fans = [
          { type = "tpacpi";
            query = "/proc/acpi/ibm/fan";
          }
    ];
    sensors = [
          { type = "tpacpi";
            query = "/proc/acpi/ibm/thermal";
          }
    ];

    levels = [
      [0     0      42]
      [1     40     47]
      [2     45     52]
      [3     50     57]
      [4     55     62]
      [5     60     77]
      [7     73     93]
      [127   85     32767]
    ];

    smartSupport = true;
  };
}
