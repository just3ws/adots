# vim:ft=zsh
# Bootstrap Zdots from XDG config.
export ZDOTDIR="$HOME/.config/zsh"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

if [[ -r "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi
