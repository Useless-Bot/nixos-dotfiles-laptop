{
  config,
  lib,
  pkgs,
  inputs,
  ly-balatro,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  hardware.alsa.enablePersistence = true;
  services.pipewire.enable = true;
#  services.pulseaudio.enable = true;
#  services.pulseaudio.support32Bit = true;
  services.upower.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aldia"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  services.udisks2.enable = true;
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  programs.niri.enable = true;
  services.displayManager.ly.package = lib.mkForce ly-balatro.packages.${pkgs.system}.default;

  services.displayManager.ly.settings = {
    animation = "balatro";
    full_color = true;
    clock = "%H:%M";

    balatro_col1 = "0x00DE443B";
    balatro_col2 = "0x000055B4";
    balatro_col3 = "0x20000000";
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hayden = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      discord
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    pfetch
    wget
    alacritty
    git
    ranger
    feh
    librewolf
    mullvad-vpn
    picom
    bat
    xclip
    burpsuite
    tealdeer
    keepassxc
    nmap
    pulsemixer
    luarocks
    gnumake
    unzip
    zig
    quickshell
    swaybg
    xwayland-satellite
    inputs.noctalia.packages.${system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";

}
