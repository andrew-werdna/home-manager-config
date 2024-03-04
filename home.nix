{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "abduke";
  home.homeDirectory = "/home/abduke";

  nixpkgs = {
    config = {
      allowUnfree = true;  
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

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

  # in order to get rust working with system packages, I had to not use nix for C related packages
  # and instead do the following:
  #     sudo apt install -y automake cmake libclang-dev libssl-dev
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    _1password-gui
    albert
    alloy6
    #autoconf # I think I need the system version of this
    #automake # I think I need the system version of this
    bazel
    #beekeeper-studio # this doesn't seem to work in a somewhat similar manner to zeal
    #binutils # ld has a name collision with ld from gcc
    bison
    brave
    cacert
    #chez # don't really need this right now
    #clang_16 # need an override or something so this doesn't collide with the gcc wrapper "cc"
    #cmake # I think I need the system version of this
    #coreutils-full # on workspaces this conflicts with builtins
    cppcheck
    discord
    #docker # I can't seem to get this to work with systemd
    docker-compose
    docker-credential-helpers
    fd
    flawfinder
    #gcc_latest # I think I need the system version of this
    #gdb # I think I need the system version of this
    #git-credential-manager # for some reason this no longer seems to work
    graphviz
    gzip
    helix
    hunspell
    hunspellDicts.en-us
    #keychain # keychain from nixpkgs must need some extra config bc it can't identify my user
    kind
    kubectl
    lsb-release
    #lldb_16 # I think I need the system version of this
    #llvm_16 # I think I need the system version of this
    #meld # going to use difftastic instead
    minikube
    mlocate
    navi
    neofetch
    nerdfonts
    netcat
    nil
    nixfmt
    obsidian
    pass
    #pika-backup # I don't need this right now
    #pinentry # collides with other versions
    #pinentry-curses # collides with other versions
    pinentry-gtk2 # needed to work with latest gnupg
    #pkg-config # I think I need the system version of this so permissions don't get messed up when using rust compiler
    #plantuml # his has similar issues to zeal, something about gtk-cranberra
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
    #virtualboxWithExtpack # can't seem to set up the kernel module with this, switching to system version
    vscode
    watch
    wireshark
    xclip
    xplr
    #zeal # for some reason this is having a problem related to gtk-cranberra or something
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
  #  /etc/profiles/per-user/abduke/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "hx";
    SHELL = "/home/abduke/.nix-profile/bin/zsh";
  };

  programs = {
    bat.enable = true;
    broot = {
      enable = true;
      enableZshIntegration = true;
    };
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
          # an outstanding [discourse post](https://discourse.nixos.org/t/cant-get-gnupg-to-work-no-pinentry/15373/8)
          # about the "no pinentry" error I keep encountering with gpg/gpg-agent
          #credentialStore = "gpg";
          #helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          #helper = "!pass git/abrown7100@github";
          helper = "store";
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
        pager = { difftool = true; };
      };
      # I need to investigate a per-repository git hooks setup
      #hooks = { pre-commit = ./pre-commit; };
      userEmail = "129974093+abrown7100@users.noreply.github.com";
      userName = "abrown7100";
    };
    gpg = {
      enable = true;
    };

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
        export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:${config.home.homeDirectory}.nix-profile/etc/systemd/system";
        export XDG_DATA_DIRS="$XDG_DATA_DIRS:${config.home.homeDirectory}.nix-profile/etc/systemd/system";
        export USER="abduke";

        #${pkgs.keychain}/bin/keychain github_duke # if I'm able to switch back to using nixpkgs keychain
        keychain github_duke

        # Goenv setup
        if [[ ! -d "$HOME/.goenv/bin" ]]; then
          git clone -v https://github.com/go-nv/goenv.git ~/.goenv
        else
          export GOENV_ROOT="$HOME/.goenv"
          export PATH="$GOENV_ROOT/bin:$PATH"
          eval "$(goenv init -)"
          export PATH="$GOROOT/bin:$PATH"
          export PATH="$PATH:$GOPATH/bin"
        fi

        # Rust setup
        if [[ ! -f "$HOME/.cargo/env" ]]; then
          curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        else
          source "$HOME/.cargo/env"
        fi

        # NVM
        if [[ ! -f "$HOME/.config/nvm/nvm.sh" ]]; then
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
          #git clone https://github.com/nvm-sh/nvm.git ~/.nvm
        else
          export NVM_DIR="$HOME/.config/nvm"
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
          [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        fi

        # Pyenv setup
        if [[ ! -d "$HOME/.pyenv/bin" ]]; then
          git clone -v https://github.com/pyenv/pyenv.git ~/.pyenv
        else
         export PYENV_ROOT="$HOME/.pyenv"
         [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
         eval "$(pyenv init -)"        
        fi

        # nsc setup for nats
        if [[ -d "$HOME/.nsccli/bin" ]]; then
          export PATH="$PATH:/home/abduke/.nsccli/bin"
        fi

        # dedupe path
        typeset -U PATH
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
        di_digests = ''docker image ls | \
        tail -n$(docker image ls | wc -l | awk '{print $1 - 1}') | \
        grep -v none | \
        tr -s ' ' | \
        cut -d' ' -f3 | \
        xargs -I {} docker inspect -f '{{printf "\nImage=%s\nDigest=%s" .RepoTags .RepoDigests}}' {}
        '';
        di_rm_nones = "docker image ls | grep none | tr -s ' ' | cut -d' ' -f3 | xargs docker rmi";

        # Go
        gotestcoverage = "go test -coverprofile cover.out ./... && go tool cover -html=cover.out && rm cover.out";

        # Misc
        _update = "sudo apt update -y && sudo apt upgrade -y --allow-downgrades && sudo apt autoclean -y && sudo apt autoremove -y";
        gitupdatehome = ''
          find "$HOME" -maxdepth 3 -type d -name .git -exec dirname {} \; | xargs -I {} git -P -C {} pull -tp
        '';
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
    gpg-agent = {
      enable = true;    
      enableScDaemon = false;
      #enableSshSupport = true;
      #extraConfig = ''
      #'';
      pinentryFlavor = "gtk2";
    };
  };
}
