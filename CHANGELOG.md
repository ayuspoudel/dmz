# Changelog

All notable changes to this project will be documented in this file.

## v3.0.0 – The Birth of `dmz`

Formerly known as `dotmanz`, now rebranded as `dmz` — a faster, smarter, and extensible ZSH system manager.

#### Highlights

- Renamed project from `dotmanz` to `dmz`
  - All binaries, paths (`~/.dotmanz` → `~/.dmz`), scripts, completions, and documentation updated
  - GitHub repository renamed; install script and release packaging fully migrated
  - Optional symlink (`dotmanz` → `dmz`) available for backward compatibility

#### Modular ZSH System

- Runtime modules now live in `zsh_modules/` (no hardcoded `.zsh` content in Rust)
- Clean separation of module categories: `core/`, `devtools/`, `prompt/`, etc.
- Added future support for `manifest.yaml` files per module

#### Bootstrap and Install Mode

- New `dmz install` command
  - Installs ZSH, Powerlevel10k, Nerd Fonts, and other shell dependencies
  - Patches `.zshrc` with a clean, idempotent loader
  - Copies over curated `.zsh` modules and completions

#### CLI Improvements

- `dmz init`: migrates legacy `.zshrc` into modular structure
- `dmz add <mod>`: enables a module by symlinking
- `dmz edit <mod>`: opens a module in the editor
- `dmz remove <mod>`: disables a module without deleting it
- `dmz refresh`: regenerates `.zshrc` and completions
- `dmz list`: lists all available and enabled modules

#### Smarter `.zshrc` Migration

- `dmz init` now:
  - Detects aliases, exports, PATH updates, functions, and plugin manager blocks
  - Groups unrecognized lines into a `migrated/` module
  - Creates timestamped backup of the original `.zshrc`
  - Supports `--dry-run` with preview output
  - Uses brace matching to handle multiline function definitions

#### CI and Packaging Updates

- GitHub Actions workflows renamed and updated:
  - `build.yml`, `test.yml`, and `release.yml`
- Release builds now include a universal macOS binary (`aarch64` + `x86_64`)
- Completion file `_dmz` is generated and packaged

#### Release Artifacts

- `dmz` universal binary
- ZSH modules directory (`zsh/`)
- Completion script (`_dmz`)
- Installer script (`install.sh`)
- Packaged as `dmz-<version>.tar.gz` for GitHub releases

#### `~/.dmz/` Becomes Config Home

- Stores enabled modules
- Stores completions
- Central source for modular ZSH configuration

With version 3.0.0, `dmz` evolves into a complete ZSH configuration manager and developer environment bootstrapper.


---
## v2.1.0

* Introduced `dotmanz init` — a full `.zshrc` migration assistant:

  * Detects and extracts aliases, exports, PATHs, functions, plugin manager lines
  * Creates appropriate module files (e.g., `aliases.zsh`, `plugins.zsh`, etc.)
  * Safely backs up original `.zshrc` with timestamps
  * Adds a clean `.zshrc` that sources all dotmanz-managed modules
  * Supports **dry-run mode** with detailed migration previews
  * Skips duplicate lines automatically and maintains visual logs of migration
* Interactive prompts via `inquire`
* Uses brace matching to migrate multiline `function` blocks
* Added grouping into `migrated/` for unclassified lines
* Future-ready migration strategy for large `.zshrc` files

This version marks the start of `dotmanz` as a full **ZSH config manager** — not just an alias tool.


---

## v2.0.6

* Updated `install.sh` to use a dynamic `VERSION` environment variable so releases are version-aware
* Shell completions are now installed automatically during setup
* `.zshrc` patching for module loader and completions is now idempotent and safe to re-run
* The `release.yml` workflow now automatically injects the correct version into `install.sh` before packaging
* Archive download and extraction are now guarded with error handling and fallback behavior
* Release archive includes the binary, zsh modules, completions, and installer script as expected

This version focuses on install-time reliability and future-proof release packaging.

---

## v2.0.5

- Added `--no-refresh` flag to `dotmanz add`
  - Skips automatic `.zshrc` refresh if desired
- `dotmanz add` now auto-runs `refresh` only if editor succeeds
  - Smart conditional behavior reduces redundant I/O
- Improved CLI output UX with colored warnings and hints
  - Shows refresh guidance after editing modules
- Added snapshot tests for:
  - `add` (module scaffold)
  - `remove` (file deletion)
  - `refresh` (idempotent `.zshrc` patching)
  - CLI integration test (`dotmanz list`)
- CI `test.yml` now validates:
  - Install script syntax
  - Rust builds/tests pass
  - CLI runs with help message
 This version focuses on robustness, test coverage, and safe automation boundaries.

## v2.0.4

- Added `dotmanz completions` subcommand
  - Supports ZSH completion script generation (`dotmanz completions zsh`)
  - Adds tab-completion for commands and flags
- Shell completion auto-installed during setup
  - `_dotmanz` is bundled in the release archive under `completions/`
  - `install.sh` copies it to `~/.zsh/completions` and patches `.zshrc`
- Modularized GitHub Actions into 3 workflows:
  - `build.yml`: Compiles and audits every commit
  - `test.yml`: Runs `cargo test`, validates install.sh
  - `release.yml`: Builds universal binary and uploads `.tar.gz` on tags
- New release archive includes:
  - `dotmanz` binary
  - `zsh/` module folder
  - `completions/_dotmanz` for ZSH shell completion
  - `install.sh` for seamless setup
-  Cleanup: Removed legacy `package.yml` workflow

---

## v2.0.3
- Fixed incorrect path resolution in installed CLI binary
    - Replaced project_root() logic with a dynamic $HOME/.dotmanz path resolver
- Added fallback support for DOTMANZ_HOME environment variable
    - Useful for sandboxing or testing in alternate directories
- Ensured dot binary runs reliably after installation regardless of working directory
    - Updated utils.rs to use the dirs crate for cross-platform home directory resolution
- Improved consistency between install script and binary behavior
    - Strengthened long-term portability and modular ZSH loading

---

## v2.0.2

- Build universal macOS binary using GitHub Actions (`aarch64` + `x86_64`)
- Automatically bundle universal binary in `.tar.gz` archive
- Updated install process to fix exec format errors on Apple Silicon Macs

---

## v2.0.1

- Automatically build and publish `.tar.gz` releases via GitHub Actions
- Added `cargo audit` step for security checks
- Dynamically generate release notes from changelog or git log
- Removed manually managed `release/` directory
- Improved CLI usability for `dot add`, `dot edit`, and `dot remove`

---

## v2.0.0

- Complete rewrite of the `dotmanz` CLI tool in Rust
- Interactive module creation with `$EDITOR` support
- List and remove modules from the ZSH config directory
- Uses modular ZSH loading from a central folder
- Supports colorized CLI output and clean messages

---

## v1.0.0

- Initial Bash-based version
- Manual `.zshrc` editing required
- No CLI interactivity or dynamic module editing
