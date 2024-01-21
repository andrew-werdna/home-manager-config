{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sirius";
  home.homeDirectory = "/home/sirius";

  nixpkgs.config.allowUnfree = true;

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

  # something to [consider](https://rycee.gitlab.io/home-manager/options.html#opt-qt.enable)
  #qt.enable = true;
  #qt.platformTheme = "gtk";
  #qt.style.name = "adwaita";

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
    bazel
    beekeeper-studio
    #binutils # ld has a name collision with ld from gcc
    bison
    brave
    cacert
    #chez # don't really need this right now
    #clang_16 # need an override or something so this doesn't collide with the gcc wrapper "cc"
    cmake
    #coreutils-full # I don't think I actually need this
    cppcheck
    discord
    #docker # I can't seem to get this to work with systemd
    docker-compose
    fd
    flawfinder
    gcc_latest
    gdb
    git-credential-manager
    graphviz
    gzip
    helix
    hunspell
    hunspellDicts.en-us
    just
    keychain
    kind
    kubectl
    lldb_16
    llvm_16
    lsb-release
    marksman
    #meld # going to use difftastic instead
    minikube
    navi
    neofetch
    nerdfonts
    netcat
    nil
    nixfmt
    obsidian
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
    bat.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    eza.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    git = {
      aliases = {
        sha = "rev-parse --short=8 HEAD";
      };
      difftastic = { enable = true; };
      enable = true;
      extraConfig = {
        credential = {
          credentialStore = "gpg";
          helper = "git-credential-manager";
        };
        diff = { tool = "difftastic"; };
        difftool = {
          "difftastic" = {
            cmd = ''
              difft "$LOCAL" "$REMOTE"
            '';
          };
          prompt = false;
        };
        init.defaultBranch = "main";
        pager = { difftool = true; };
      };
      # I need to investigate a per-repository git hooks setup
      #hooks = { pre-commit = ./pre-commit; };
      userEmail = "8261769+andrew-werdna@users.noreply.github.com";
      userName = "andrew-werdna";
    };
    gpg.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    htop.enable = true;
    jq.enable = true;
    #nushell.enable = true; # I want to learn this but not this moment
    ssh = { enable = true; };
    starship.enable = true;
    tealdeer = {
      enable = true;
      settings = { auto_update = true; };
    };
    tmux = {
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      enable = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      shell = "${pkgs.zsh}/bin/zsh";
    };
    zsh = {
      autocd = true;
      defaultKeymap = "viins";
      enable = true;
      enableAutosuggestions = true;
      initExtra = ''
        keychain id_ed25519
        # GOENV
        if [[ -d "$HOME/.goenv/" ]]; then
          export GOENV_ROOT="$HOME/.goenv"
          export PATH="$GOENV_ROOT/bin:$PATH"
          eval "$(goenv init -)"
          export PATH="$GOROOT/bin:$PATH"
          export PATH="$PATH:$GOPATH/bin"
        fi
        # Rustup
        if [[ -f "$HOME/.cargo/env" ]]; then
          source "$HOME/.cargo/env"
        fi
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "kubectl" "starship" "vi-mode" ];
        theme = "agnoster";
      };
      shellGlobalAliases = {
        # Code Maat
        #maat = "java -jar ~/bin/code-maat-1.0.4-standalone.jar -c git2";
        #maat_logfile = "git log --all --numstat --date=short --pretty=format:'--%h--%ad--%aN' --no-renames";

        # Docker
        di_digests = "docker image ls | tail -n\$(docker image ls | wc -l | awk '{print \$1 - 1}') | grep -v none | tr -s ' ' | cut -d' ' -f3 | xargs -I {} docker inspect -f '{{printf \"\nImage=%s\nDigest=%s\" .RepoTags .RepoDigests}}' {}";
        di_rm_nones = "docker image ls | grep none | tr -s ' ' | cut -d' ' -f3 | xargs docker rmi";

        # Go
        gotestcoverage = "go test -coverprofile cover.out ./... && go tool cover -html=cover.out && rm cover.out";

        # Misc
        _update = "sudo apt update -y && sudo apt upgrade -y --allow-downgrades && sudo apt autoclean -y && sudo apt autoremove -y";
        gitp = "git -P";
        hmedit = "hx ~/.config/home-manager/";
        reshell = "exec $SHELL";

        # Network
        network_restart = "sudo systemctl restart systemd-networkd";
     };
     syntaxHighlighting = { enable = true; };
    };
  };

  services = {
    copyq.enable = true;
    gpg-agent.enable = true;
  };
}
