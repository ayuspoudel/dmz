# Changelog

All notable changes to this project will be documented in this file.

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
