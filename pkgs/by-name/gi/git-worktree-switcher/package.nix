{ lib, stdenv, fetchFromGitHub, makeWrapper, installShellFiles, git, jq }:

stdenv.mkDerivation rec {
  pname = "git-worktree-switcher";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mateusauler";
    repo = "git-worktree-switcher";
    rev = "refs/tags/${version}-fork";
    hash = "sha256-fjY+ieUI7m/4gb68/1a+90aIc9iMyQortVd7oHN4STw=";
  };

  buildInputs = [
    jq
    git
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  patches = [
    ./disable-update.patch # Disable update and auto update functionality
    ./add_list_option.patch # Add `list` option to be more intuitive (`git worktree list`)
  ];

  installPhase = ''
    mkdir -p $out/bin

    cp wt $out/bin
    wrapProgram $out/bin/wt --prefix PATH : ${lib.makeBinPath [ git jq ]}

    installShellCompletion --zsh completions/_wt_completion
    installShellCompletion --bash completions/wt_completion
    installShellCompletion --fish completions/wt.fish
  '';

  meta = with lib; {
    homepage = "https://github.com/mateusauler/git-worktree-switcher";
    description = "Switch between git worktrees with speed.";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jiriks74 ];
  };
}
