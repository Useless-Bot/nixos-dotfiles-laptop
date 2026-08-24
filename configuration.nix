{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
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
  security.rtkit.enable =true;
  services.upower.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aldia"; # Define your hostname.

  networking.networkmanager.enable = true;
  services.udisks2.enable = true;
  time.timeZone = "America/Los_Angeles";

  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = { 
    default_session = { 
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      };
    };
  };

  users.users.hayden = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
    ];

    packages = with pkgs; [
      tree
      discord
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    wget
    alacritty
    git
    ranger
    feh
    librewolf
    mullvad-vpn
    bat
    btop
    tree-sitter
    xclip
    burpsuite
    tealdeer
    keepassxc
    nmap
    luarocks
    gnumake
    unzip
    zig
    quickshell
    lua-language-server
    swaybg
    xwayland-satellite
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
