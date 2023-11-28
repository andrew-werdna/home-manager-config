{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sirius";
  home.homeDirectory = "/home/sirius";

  nixpkgs.config.allowUnfree = true;

  # something to [consider](https://rycee.gitlab.io/home-manager/options.html#opt-qt.enable)
  #qt.enable = true;
  #qt.platformTheme = "gtk";
  #qt.style.name = "adwaita";

  # I found a [gist](https://gist.github.com/nat-418/903c8e8ef605c36c2e3ed9a8e9ed0cea) in which someone was able
  # to get zeal working by using some GTK stuff instead of QT. If this works, then it will eliminate the need for
  # the above stuff messing with QT.
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    theme = {
      name = "Adwaita";
      package = pkgs.gnome.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  targets.genericLinux.enable = true;

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.userDirs.enable = true;

  # I found this solution on the lengthy thread about HM installed applications not being findable in GNOME application search
  # The link to the exact comment is [here](https://github.com/nix-community/home-manager/issues/1439#issuecomment-1106208294).
  # Since I enabled xdg stuff above, I'm not certain that this below section is really necessary anymore as I've noticed
  # when using the application finder, that there are now two copies of each installed application.
  # I have discovered that the xdg enable stuff above _will_ in fact update `*.desktop` entries, but GNOME won't pick up the
  # changes due to them being symbolic links. Currently, one has to log out and then log back in for the changes to be detected.
  # I'm still searching for a solution so logging in/out afterwards is no longer necessary.

  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        # these commands end up creating duplicates once I log out and then log back in, I just need to figure out how to
        # not need to log out and then back in

        #rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        #mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        #cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
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
  home.packages = with pkgs; [
    _1password-gui
    albert
    alloy6
    autoconf
    automake
    bat
    bazel
    beekeeper-studio
    #binutils # ld has a name collision with ld from gcc
    bison
    brave
    #chez # don't really need this right now
    #clang_16 # need an override or something so this doesn't collide with the gcc wrapper "cc"
    cmake
    copyq
    coreutils-full
    cppcheck
    discord
    docker
    docker-compose
    fd
    flawfinder
    gcc_latest
    gdb
    #gnupg # not sure I need this if I use `gpg.enable = true;`
    graphviz
    gzip
    helix
    htop
    hunspell
    hunspellDicts.en-us
    jq
    keychain
    kind
    kubectl
    lldb_16
    llvm_16
    #meld # going to use difftastic instead
    minikube
    navi
    neofetch
    nerdfonts
    netcat
    nil
    nixfmt
    obsidian
    #openssh # not sure I need this if I have `programs.ssh.enable = true;`
    pass
    #pika-backup # I don't need this right now
    pkg-config
    pprof
    qalculate-gtk
    #racket # don't really need this right now
    ranger
    #remmina # don't need this right now
    ripgrep
    strace
    texlab
    tlaplusToolbox
    tree
    tree-sitter
    #tmux # don't need this if I use `programs.tmux = ...`
    valgrind
    #virt-manager # don't need this right now
    vscode
    watch
    wireshark
    xclip
    xplr
    zeal # for some reason this is having a problem related to QT or GTK, so it won't run currently
    zellij
    zig
    zls

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
    SHELL = "/home/sirius/.nix-profile/bin/zsh";
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza.enable = true;
    fzf.enable = true;
    git = {
      difftastic = { enable = true; };
      enable = true;
      extraConfig = {
        diff = { tool = "difftastic"; };
        difftool = {
          "difftastic" = {
            cmd = ''
              difft "$LOCAL" "$REMOTE"
            '';
          };
          prompt = false;
        };
        pager = { difftool = true; };
      };
      userName = "andrew-werdna";
      userEmail = "8261769+andrew-werdna@users.noreply.github.com";
    };
    gpg.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    #nushell.enable = true; # I want to learn this but not this moment
    ssh = { enable = true; };
    starship.enable = true;
    tealdeer = {
      enable = true;
      settings = { auto_update = true; };
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      shell = "${pkgs.zsh}/bin/zsh";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      autocd = true;
      defaultKeymap = "viins";
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "kubectl" "starship" "vi-mode" ];
        theme = "agnoster";
      };
      syntaxHighlighting = { enable = true; };
    };
  };

  services = { gpg-agent.enable = true; };
}
