#!/usr/bin/env bash
# adots bootstrap — safe home blanket check.
#
# adots does not install the platform. zdots is the closed system that owns
# Homebrew, runtime installs, services, and bootstrap side effects.

set -euo pipefail

homegit() {
  git --git-dir="$HOME/.homegit" --work-tree="$HOME" "$@"
}

echo "adots bootstrap: checking home blanket"

if [[ ! -d "$HOME/.homegit" ]]; then
  echo "adots bootstrap: ~/.homegit missing"
  echo "  install adots with:"
  echo "  git clone --bare https://github.com/just3ws/adots.git ~/.homegit"
  exit 1
fi

homegit config --local status.showUntrackedFiles no
echo "adots bootstrap: ~/.homegit present"

if [[ ! -d "$HOME/.config/zsh" ]]; then
  echo "adots bootstrap: zdots missing at ~/.config/zsh"
  echo "  clone it, then let zdots own platform bootstrap:"
  echo "  git clone https://github.com/just3ws/zdots.git ~/.config/zsh"
  echo "  ~/.config/zsh/bin/bootstrap"
else
  echo "adots bootstrap: zdots present"
fi

if [[ ! -d "$HOME/.config/nvim" ]]; then
  echo "adots bootstrap: vdots missing at ~/.config/nvim"
  echo "  clone it when editor setup is needed:"
  echo "  git clone https://github.com/just3ws/vdots.git ~/.config/nvim"
else
  echo "adots bootstrap: vdots present"
fi

if [[ -x "$HOME/bin/adots-doctor" ]]; then
  if [[ "${1:-}" == "--fix" ]]; then
    "$HOME/bin/adots-doctor" --fix
  else
    "$HOME/bin/adots-doctor"
  fi
else
  echo "adots bootstrap: adots-doctor missing; restore adots tracked files"
fi
