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
    pkgs.autoconf
    pkgs.automake
    pkgs.beekeeper-studio
    #pkgs.binutils # ld has a name collision with ld from gcc
    pkgs.bison
    pkgs.brave
    #pkgs.clang_16 # need an override or something so this doesn't collide with the gcc wrapper "cc"
    pkgs.copyq
    pkgs.coreutils-full
    pkgs.cmake
    pkgs.docker
    pkgs.docker-compose
    pkgs.gcc_latest
    pkgs.gnupg
    pkgs.gzip
    pkgs.helix
    pkgs.jq
    pkgs.keychain
    pkgs.kind
    pkgs.kubectl
    pkgs.llvm_16
    pkgs.minikube
    pkgs.neofetch
    pkgs.nerdfonts
    pkgs.netcat
    pkgs.nil
    pkgs.obsidian
    pkgs.openssh
    pkgs.pass
    pkgs.pkg-config
    pkgs.pprof
    pkgs.ranger
    pkgs.ripgrep
    pkgs.starship
    pkgs.texlab
    pkgs.tree-sitter
    pkgs.tmux
    pkgs.vscode
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
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.nushell.enable = true;

  programs.git = {
    enable = true;
    userName = "andrew-werdna";
    userEmail = "8261769+andrew-werdna@users.noreply.github.com";
  };

}
