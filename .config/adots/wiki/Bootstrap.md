# Bootstrap

adots is restored as part of the [zdots](https://github.com/just3ws/zdots/wiki)
bootstrap — you do not clone it by hand on a fresh machine.

## Cold start on a new machine

```bash
git clone https://github.com/just3ws/zdots.git ~/.config/zsh
~/.config/zsh/bin/bootstrap
```

zdots bootstrap handles everything: Homebrew, **this repo (adots)**, vdots, Ruby,
the AI stack, local services, and database init. adots is cloned and restored
automatically as part of that process.

## Work-machine restore

> [!TIP]
> For the end-to-end AI agent playbook that safely evaluates, reconciles, and migrates `adots`, `zdots`, and `vdots` onto a corporate machine (preserving existing IT setups, 1Password, Postgres 17, Colima, and mise), see the **[Work Machine Migration Playbook](~/.config/zsh/docs/work-migration-playbook.md)** in the `zdots` repository.

On a managed machine, restore the minimal safe set first and let the doctor
guide the rest. Never restore over a file that already exists: an employer
setup often owns `~/.gitconfig` (identity, commit signing) and `~/.zshenv`
(checked line by line), so those are **merged**, not restored — append the
adots include to `~/.gitconfig` and one bridge line to `~/.zshenv` (see the
playbook, Phases 4.3 and 5.2), then mark them `skip-worktree`.

```bash
git clone --bare https://github.com/just3ws/adots.git ~/.homegit
git --git-dir=$HOME/.homegit --work-tree=$HOME reset -q   # load the index; touches no files
git --git-dir=$HOME/.homegit --work-tree=$HOME status -s  # ' D' = absent, ' M'/' T' = collides
git --git-dir=$HOME/.homegit --work-tree=$HOME restore --source=HEAD -- \
  README.md bootstrap.sh bin/adots-doctor bin/adots-profile .bashrc .bash_profile .profile
~/bin/adots-profile work
~/bin/adots-doctor            # read-only; never --fix on a managed machine
```

**Review the doctor output before restoring the full tracked set.** On managed
machines, inspect `.gitconfig`, the shell entrypoints, and tool configs before
touching employer-managed files, and restore `.config/git/config` only once
`git-delta`, `neovim` and `git-lfs` are installed (git reads it immediately).

## Doctor first

`adots-doctor` audits the home layout without mutating anything by default. Read
its report, then apply repairs deliberately:

```bash
adots-doctor          # audit only
adots-doctor --fix    # repair safe drift
```

See [XDG Layout](XDG-Layout.md) for what the doctor enforces and why it fails
rather than guessing when a path is ambiguous.
