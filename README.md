# adots
The alpha layer for home directory configurations.

## Architecture: The Modular Trinity
`adots` is the foundational "anchor" repo that orchestrates your environment. It manages root-level dotfiles and system-wide packages, while delegating specific tool domains to modular sister repositories:

1.  **adots (~)**: This repository. Tracks root configs (`.zshenv`, `.gitconfig`, `.ackrc`) and bootstrap logic.
2.  **zdots (~/.config/zsh)**: The "Deepened Shell Platform." Handles shell logic, OTel observability, and MCP integrations.
3.  **gdots (~/.config/git)**: Global Git configuration, delta styling, and system-wide ignore rules.
4.  **my (~/my)**: The "Cerebral Control Plane." A monorepo for local-first AI context, standards, and the "Shell Brain" (PostgreSQL context).

## Bootstrap
Run `./bootstrap.sh` to ensure all system dependencies (Homebrew, Brewfile) are installed and the environment is ready for the modular components.
