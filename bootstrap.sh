#!/bin/bash
# adots bootstrap - The alpha layer setup script

set -e

echo "🚀 Starting adots bootstrap..."

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

# 3. Ensure Pi is installed (via recommended script)
echo "Ensuring Pi coding agent is installed..."
curl -fsSL https://pi.dev/install.sh | sh

# 4. Setup homegit alias if not in current shell
if ! command -v homegit &> /dev/null; then
    alias homegit='/usr/bin/git --git-dir=$HOME/.homegit/ --work-tree=$HOME'
fi

# 5. Hide untracked files
homegit config --local status.showUntrackedFiles no

echo "✅ adots bootstrap complete!"
