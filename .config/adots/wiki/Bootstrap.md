# Bootstrap

adots is restored as part of the zdots bootstrap — you do not clone it by hand on
a fresh machine.

## Cold start on a new machine

```bash
git clone https://github.com/just3ws/zdots.git ~/.config/zsh
~/.config/zsh/bin/bootstrap
```

zdots bootstrap handles everything: Homebrew, **this repo (adots)**, vdots, Ruby,
the AI stack, local services, and database init. adots is cloned and restored
automatically as part of that process.

## Work-machine restore

On a managed machine, restore the minimal safe set first and let the doctor
guide the rest:

```bash
git clone --bare https://github.com/just3ws/adots.git ~/.homegit
git --git-dir=$HOME/.homegit --work-tree=$HOME restore --source=HEAD -- \
  README.md bootstrap.sh bin/adots-doctor .gitconfig .config/git/config \
  .zshenv .bashrc .bash_profile .profile
~/bin/adots-doctor
```

**Review the doctor output before restoring the full tracked set.** On managed
machines, inspect `.gitconfig`, the shell entrypoints, and tool configs before
overwriting employer-managed files.

## Doctor first

`adots-doctor` audits the home layout without mutating anything by default. Read
its report, then apply repairs deliberately:

```bash
adots-doctor          # audit only
adots-doctor --fix    # repair safe drift
```

See [XDG Layout](XDG-Layout.md) for what the doctor enforces and why it fails
rather than guessing when a path is ambiguous.
