#!/bin/bash
# adots bootstrap - The alpha layer setup script

set -e

# Utility: ASCII Banner
banner() {
    echo "$1" | boxes -d stone -p a2
}

banner "🚀 adots bootstrap
The Alpha Layer"

# 1. Install Homebrew if missing
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Bundle from Brewfile
if [ -f "$HOME/.config/zsh/Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$HOME/.config/zsh/Brewfile"
fi

# 3. Ensure Pi is installed
echo "Ensuring Pi coding agent is installed..."
curl -fsSL https://pi.dev/install.sh | sh

# 4. Setup homegit alias
if ! command -v homegit &> /dev/null; then
    alias homegit='/usr/bin/git --git-dir=$HOME/.homegit/ --work-tree=$HOME'
fi

# 5. Hide untracked files
homegit config --local status.showUntrackedFiles no

# 6. Verify Modular Ecosystem
echo "Checking sister repositories..."
[ -d "$HOME/.config/zsh" ] || echo "⚠️  Warning: zdots (~/.config/zsh) not found."
[ -d "$HOME/.config/git" ] || echo "⚠️  Warning: gdots (~/.config/git) not found."
[ -d "$HOME/my" ] || echo "⚠️  Warning: my (~/my) not found."

banner "✅ adots bootstrap complete!
Environment Deepened."
