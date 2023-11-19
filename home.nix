{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sirius";
  home.homeDirectory = "/home/sirius";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  xdg.enable = true;
  xdg.mime.enable = true;

  # I found this solution on the lengthy thread about HM installed applications not being findable in GNOME application search
  # The link to the exact comment is [here](https://github.com/nix-community/home-manager/issues/1439#issuecomment-1106208294).
  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
      '';
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs._1password-gui
    pkgs.alloy6
    pkgs.autoconf
    pkgs.automake
    pkgs.bat
    pkgs.beekeeper-studio
    #pkgs.binutils # ld has a name collision with ld from gcc
    pkgs.bison
    pkgs.brave
    pkgs.chez
    #pkgs.clang_16 # need an override or something so this doesn't collide with the gcc wrapper "cc"
    pkgs.cmake
    pkgs.copyq
    pkgs.coreutils-full
    pkgs.cppcheck
    pkgs.docker
    pkgs.docker-compose
    pkgs.fd
    pkgs.flawfinder
    pkgs.gcc_latest
    pkgs.gnupg
    pkgs.graphviz
    pkgs.gzip
    pkgs.helix
    pkgs.htop
    pkgs.jq
    pkgs.keychain
    pkgs.kind
    pkgs.kubectl
    pkgs.llvm_16
    pkgs.minikube
    pkgs.navi
    pkgs.neofetch
    pkgs.nerdfonts
    pkgs.netcat
    pkgs.nil
    pkgs.nixfmt
    pkgs.obsidian
    pkgs.openssh
    pkgs.pass
    pkgs.pkg-config
    pkgs.pprof
    pkgs.racket
    pkgs.ranger
    pkgs.ripgrep
    pkgs.texlab
    pkgs.tlaplusToolbox
    pkgs.tree
    pkgs.tree-sitter
    pkgs.tmux
    pkgs.vscode
    pkgs.watch
    pkgs.xplr
    pkgs.zeal
    pkgs.zellij
    pkgs.zig
    pkgs.zls

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sirius/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.eza.enable = true;
  programs.git = {
    enable = true;
    userName = "andrew-werdna";
    userEmail = "8261769+andrew-werdna@users.noreply.github.com";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nushell.enable = true;
  programs.starship.enable = true;
}
