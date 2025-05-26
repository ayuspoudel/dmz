# dotmanz

[![Build dotmanz](https://github.com/ayuspoudel/dotmanz/actions/workflows/build.yml/badge.svg)](https://github.com/ayuspoudel/dotmanz/actions/workflows/build.yml)
[![Test dotmanz](https://github.com/ayuspoudel/dotmanz/actions/workflows/test.yml/badge.svg)](https://github.com/ayuspoudel/dotmanz/actions/workflows/test.yml)
[![Release dotmanz](https://github.com/ayuspoudel/dotmanz/actions/workflows/release.yml/badge.svg)](https://github.com/ayuspoudel/dotmanz/actions/workflows/release.yml)\
A modern, Rust-powered CLI tool to manage modular ZSH configuration files.

## Overview

`dotmanz` is a command-line utility that helps developers organize, edit, and interact with modular `.zsh` files through an intuitive CLI experience. Instead of manually editing config files, you can now use commands like:

```bash
dotmanz list
```

```bash
dotmanz add aws
```

```bash
dotmanz edit git
```

## Features (v2.0.0+)

* Rust-based binary with universal macOS support
* Interactive CLI to create, view, edit, or delete `.zsh` modules
* Opens your `$EDITOR` for direct file editing
* Autoloads config from a standard modular layout
* Works with any shell that can source `.zshrc`

## Installation

### 1. Download from Releases

Visit [Releases](https://github.com/ayuspoudel/dotmanz/releases) and download the latest `.tar.gz` package.

Or via terminal:

```bash
curl -L -o dotmanz.tar.gz https://github.com/ayuspoudel/dotmanz/releases/download/v2.0.2/dotmanz-v2.0.2.tar.gz
tar -xzf dotmanz.tar.gz
cd dotmanz-v2.0.2
./install.sh
```

### 2. Reload your shell

```bash
source ~/.zshrc
```

## Documentation

* [Version 1.x Architecture](V1.md)
* [Developer Internals](DEVELOPER_GUIDE.md)
* [Changelog](CHANGELOG.md)

---

### Coming Soon

* `.deb` packaging for Linux
* Shell completions
* Plugin marketplace
* Sync and refresh integrations
