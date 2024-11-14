{
  config,
  pkgs,
  lib,
  ...
}:

let
  prg = config.programs;
  cfg = prg.git-worktree-switcher;

  initScript = ''
    eval "$(command ${pkgs.git-worktree-switcher}/bin/wt init $(basename $SHELL))"
  '';
in
{
  options = {
    programs.git-worktree-switcher = {
      enable = lib.mkEnableOption "git-worktree-switcher, switch between git worktrees with speed.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git-worktree-switcher ];

    programs.bash.interactiveShellInit = initScript;
    programs.zsh.interactiveShellInit = lib.mkIf prg.zsh.enable initScript;
    programs.fish.interactiveShellInit = lib.mkIf prg.fish.enable initScript;
  };
}
