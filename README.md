# dmz

[![Build dmz](https://github.com/ayuspoudel/dmz/actions/workflows/build.yml/badge.svg)](https://github.com/ayuspoudel/dmz/actions/workflows/build.yml)
[![Test dmz](https://github.com/ayuspoudel/dmz/actions/workflows/test.yml/badge.svg)](https://github.com/ayuspoudel/dmz/actions/workflows/test.yml)
[![Release dmz](https://github.com/ayuspoudel/dmz/actions/workflows/release.yml/badge.svg)](https://github.com/ayuspoudel/dmz/actions/workflows/release.yml)\
A modern, Rust-powered CLI tool to manage modular ZSH configuration files.

## Overview

`dmz` is a command-line utility that helps developers organize, edit, and interact with modular `.zsh` files through an intuitive CLI experience. Instead of manually editing config files, you can now use commands like:

```bash
dmz list
```

```bash
dmz add aws
```

```bash
dmz edit git
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
# Download the latest release (v2.2.0 here, replace with the newest tag if needed)
curl -L -o dmz.tar.gz https://github.com/ayuspoudel/dmz/releases/download/v2.2.0/dmz-v2.2.0.tar.gz

# Extract
tar -xzf dmz.tar.gz

# Enter package dir
cd dmz-v2.2.0

# Run installer
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
