# Changelog

All notable changes to this project will be documented in this file.

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
