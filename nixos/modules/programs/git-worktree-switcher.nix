{
  config,
  pkgs,
  lib
}:

let
  prg = config.programs;
  cfg = prg.git-worktree-switcher;

  bashInitScript = ''
    eval "$(command ${pkgs.git-worktree-switcher}/bin/wt init bash)"
  '';
  zshInitScript = ''
    eval "$(command ${pkgs.git-worktree-switcher}/bin/wt init zsh)"
  '';
  fishInitScript = ''
    eval "$(command ${pkgs.git-worktree-switcher}/bin/wt init zsh)"
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

    programs.bash.interactiveShellInit = bashInitScript;
    programs.zsh.interactiveShellInit = lib.mkIf prg.zsh.enable zshInitScript;
    programs.fish.interactiveShellInit = lib.mkIf prg.fish.enable fishInitScript;
  };
}
