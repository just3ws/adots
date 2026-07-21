# Legacy Ruby (2.x) via mise

Ruby 2.x requires OpenSSL 1.1, which Homebrew has removed entirely, and
mise/ruby-build autodetects Homebrew's `openssl@3` — so a plain
`mise install ruby@2.6.10` dies compiling `ext/openssl` with
`-Wdeprecated-declarations` errors. Ruby 2.6.10 itself compiles cleanly on
arm64; OpenSSL is the only blocker.

## Install

```bash
mise-ruby-legacy            # ruby 2.6.10 (default)
mise-ruby-legacy 2.7.8      # any 2.x version
```

The script (tracked at `~/bin/mise-ruby-legacy`) does three things:

1. Builds a private **static OpenSSL 1.1.1w** into `~/.local/opt/openssl-1.1.1w`
   (one-time, sha256-pinned download from the openssl GitHub releases).
2. Symlinks a CA bundle (`Homebrew ca-certificates`, falling back to
   `/etc/ssl/cert.pem`) into the prefix — a source-built OpenSSL ships no
   certs, so TLS verification fails without this.
3. Runs `RUBY_CONFIGURE_OPTS="--with-openssl-dir=<prefix>" mise install ruby@<version>`
   and verifies: `ruby -v`, `OpenSSL::OPENSSL_VERSION`, and a live HTTPS GET.

## Repair

Everything is idempotent — re-running the script is the repair path.

| Symptom | Fix |
|---|---|
| Suspect broken OpenSSL build | `rm -rf ~/.local/opt/openssl-1.1.1w && mise-ruby-legacy` |
| Suspect broken Ruby install | `mise uninstall ruby@2.6.10 && mise-ruby-legacy` |
| `certificate verify failed` | Re-run the script (re-links `cert.pem`), or `brew install ca-certificates` |

## Known-cosmetic

- The `gdbm` extension fails to build and is skipped by ruby-build. Nothing
  we use needs gdbm.
- OpenSSL 1.1.1 is EOL (Sep 2023). This is a build-time dependency for a
  legacy interpreter, statically linked and private to these rubies — do not
  put its `bin/` on `PATH` or link other software against it.
