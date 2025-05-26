# dotmanz Developer Guide

This document explains how the current `dotmanz` CLI (v2+) is implemented in Rust, what design principles it follows, and how to contribute or extend the system.

---

## Purpose

The CLI replaces the need to manually manage ZSH module files. Instead of editing `~/Code/dotfiles/zsh/*.zsh` manually, users can now do:

```bash
dotmanz add aws
dotmanz edit git
dotmanz list
````

---

## Project Structure

```
src/
├── main.rs               # CLI entry point
├── cli.rs                # CLI argument parser
├── constants.rs          # Global constants (unused now)
├── utils.rs              # Path resolver for .zshrc and zsh/ folder
├── commands/
│   ├── add.rs            # dotmanz add
│   ├── edit.rs           # dotmanz edit
│   ├── list.rs           # dotmanz list
│   ├── remove.rs         # dotmanz remove
│   ├── refresh.rs        # dotmanz refresh (placeholder)
│   └── mod.rs            # Mod aggregator
```

---

## Path Resolution Logic

To make the tool portable and predictable, all commands operate on:

```rust
~/.dotmanz/zsh
~/.zshrc
```

These are resolved in `utils.rs` using:

```rust
dirs::home_dir().unwrap().join(".dotmanz/zsh")
```

---

## Command Flow

### `dotmanz list [module]`

* Lists all `.zsh` modules
* If a module is passed, prints the file contents with highlighted alias lines

### `dotmanz add [module]`

* If no module is passed, opens a list prompt (`inquire::Select`)
* Final option allows creating a new module
* Launches `$EDITOR` to edit the module
* On exit, triggers a `refresh.rs` placeholder for future logic

### `dotmanz edit [module]`

* Same as `add` but skips the "create new" option

### `dotmanz remove [module]`

* Warns the user about deletion
* Opens prompt if module not supplied
* Deletes file and confirms

---

## Editor Integration

Uses:

```rust
let editor = std::env::var("EDITOR").unwrap_or("vi".to_string());
Command::new(editor).arg(path).status()
```

It pauses execution until the editor is closed.

---

## Terminal UI (inquire)

* `Select` prompt for module list
* `Text` input for naming new modules

---

## Installation

Binaries are prebuilt via GitHub Actions and distributed via `.tar.gz` with an `install.sh`.

The installer:

* Moves binary to `/usr/local/bin/dotmanz`
* Creates `~/.dotmanz/zsh`
* Updates `~/.zshrc` to source all modules dynamically

---

## GitHub Workflow

* Runs on tag push (`v*`)
* Builds a **universal macOS binary** (Intel + ARM via `lipo`)
* Compresses all assets into `dotmanz-vX.Y.Z.tar.gz`
* Publishes a GitHub release with metadata

---

## Contributing

Run locally:

```bash
cargo run -- list
cargo run -- add git
cargo run -- edit aws
```

Build release binary:

```bash
cargo build --release
```

---

## Roadmap

* Shell completion support
* Plugin discovery
* Sync integration (`dotmanz refresh`)
* Auto-lint and validate aliases