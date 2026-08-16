{
  config,
  inputs,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    alacritty = "alacritty";
    ranger = "ranger";
    librewolf = "librewolf";
    niri = "niri";
    noctalia = "noctalia";
  };
in

#Home-manager setup

{
  home.username = "hayden";
  home.homeDirectory = "/home/hayden";
  programs.git.enable = true;
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      clear = "pyroclear --random";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#aldia";
    };
  };

  #packages
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
    ripgrep
    nodejs
    gcc
  ];

  #Recursion for dotfiles, programs to look for are defined above.
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
  #Program configs.
  programs.rofi = {
    enable = true;

    theme = "gruvbox-dark-soft";

    modes = [
      "drun"
      "run"
      "window"
    ];

    extraConfig = {
      show-icons = true;
    };
  };

  services.udiskie = {
    enable = true;
    settings = {
    };
  };
}
