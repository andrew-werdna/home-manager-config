# Home Manager

This is my _(in progress)_ work of having a flake-based, standalone, home-manager installation that will manage the 
_ubiquitous_ tools and applications I use as well as my dotfiles.

My intent is to use something like [the nix way dev templates](https://github.com/the-nix-way/dev-templates) for
_per project_ tools and dependencies.

## Todos for Home Manager

- set my default shell (between `nushell` and `zsh`)
- have updated shell configuration managed and symlinked by HM (HM already manages configs, I just need to customize them)
  - also automatically set up zsh and nushell with starship
- finish customizing my `git config` and `git-related` files
- now that I've solved the `*.desktop` files being findable by the GNOME application explorer, I just need to customize
the application icons for the various applications I've installed
- use overrides and overlays to customize the packages I've installed
- ideally find more flake-based resources for developer environments
- switch to having as many dotfiles (not just my shell) as possible, fully managed, customized, and symlinked by HM
- 
