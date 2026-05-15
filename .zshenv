# vim:ft=zsh
# Bootstrap Zdots from XDG config.
export ZDOTDIR="$HOME/.config/zsh"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# FZF Dracula Pro (Van Helsing) Theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ff79c6,header:#6272a4'

if [[ -r "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi
