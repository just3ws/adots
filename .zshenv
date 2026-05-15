# vim:ft=zsh
# Bootstrap Zdots from XDG config.
export ZDOTDIR="$HOME/.config/zsh"

if [[ -r "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi
