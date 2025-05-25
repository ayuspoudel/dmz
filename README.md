Here’s your **updated `README.md`** with:

* A clear **pre-requisite structure**
* Explanation of the new `automation.zsh` module
* All prior sections preserved and improved for clarity

---

```markdown
## ZSH Automation System — dotmanz

### Prerequisite: Folder Structure

This setup assumes your ZSH environment lives under a `~/Code` directory, with the following convention:

```

\~/Code/
├── dotfiles/         # This repo (your modular zsh config)
│   └── zsh/
├── bin/              # Your automation scripts (custom CLI tools, git-enhanced, etc.)

````

If you prefer a different layout (e.g. `~/configs/zsh`), **you must update paths in `aliases.zsh`, `path.zsh`, and possibly `.zshrc`** to match your structure.

---

### What this is

This folder contains a fully modular ZSH configuration setup.  
It is intended to replace the common mess that builds up inside a `.zshrc` file over time.

Instead of writing all aliases, environment variables, plugin sourcing, and prompt settings in one file, this setup **splits everything into individual files** that are easier to understand, manage, and update.

You don’t need to know ZSH scripting to use this.  
You only need to know that each file in this folder has a specific purpose, and your terminal will load it automatically.

---

### Why this was created

Before this structure, everything lived inside `.zshrc`. That included aliases, plugin sourcing, custom functions, exports, environment variables, and more. Over time, the file grew large and difficult to manage.

Eventually, I made a mistake:  
I accidentally used the `>` operator instead of `>>` while trying to add something to `.zshrc`, and it completely erased the file.

That was the turning point.

I decided I needed a setup that:

* Would **never require me to scroll through 1000+ lines** to find a Git alias  
* Would allow me to **safely organize and preserve** small sets of related configuration  
* Would let **anyone else using this system understand how to extend it immediately**  
* Would support **private secrets separately** without polluting the public config  
* Would let me run commands like `a.aws` or `a.terraform` to explore what I had  

---

### How this works

Your `.zshrc` file is minimal and only does one thing:  
It **sources everything** inside this folder.

Every file inside this folder ends with `.zsh` and is treated as a **module**. These modules are:

* Automatically loaded every time you open your terminal  
* Small and scoped to one category (like `aws.zsh` for AWS aliases)

You can edit any file independently. If you make a mistake in one, it won’t affect the others.

---

### How to set it up

1. Clone this repo:

```bash
git clone https://github.com/ayuspoudel/dotmanz ~/Code/dotfiles
````

2. Make sure your `.zshrc` file looks like this:

```zsh
ZSH_CONFIG="$HOME/Code/dotfiles/zsh"

for config_file in "$ZSH_CONFIG"/*.zsh; do
  source "$config_file"
done

[[ -f "$ZSH_CONFIG/private.zsh" ]] && source "$ZSH_CONFIG/private.zsh"
```

3. Reload your config:

```bash
source ~/.zshrc
```

---

### The intent behind each file

These files are modular and scoped. Add more if needed.

#### aliases.zsh

General-purpose aliases like `cls`, `czsh`, `szsh`, and quick `cd` helpers.
If you change your folder structure, update paths in this file.

#### aws.zsh

Aliases for AWS CLI (EC2, IAM, Lambda, S3, etc.)

#### docker.zsh

Docker and Compose aliases like `dcu`, `dps`, `dcl`, etc.

#### dynatrace.zsh

Dynatrace environment setup (non-secret values only)

#### git.zsh

Git CLI shortcuts — `gpush`, `gco`, `glog`, etc.

#### terraform.zsh

Terraform helpers including `tfcleanapply` to reset and re-init

#### helpers.zsh

Magic behind `a.<group>` aliases — like:

```bash
a.aws            # List AWS aliases
a.git push       # Search Git aliases for push-related commands
help             # List all defined groups
```

#### path.zsh

Adds `~/Code/bin` to your PATH so scripts are globally runnable

#### plugins.zsh

Loads ZSH plugins like autosuggestions and syntax highlighting safely

#### prompt.zsh

Defines your terminal appearance — username, folder, git branch, time

#### private.zsh

Your sensitive data: API tokens, profile exports, etc.
**This file is ignored by Git** and should be created manually.

#### safety.zsh

Protects you by making `rm` interactive, formatting `less`, and improving shell history timestamps.

#### automation.zsh

Allows you to run scripts stored in `~/Code/bin/` using:

```bash
run                 # Lists all available scripts
run gq              # Executes gq if it's in ~/Code/bin/
```

Use this to manage automation workflows, such as Git workflows, deployment helpers, or API tooling.

---

### How to add more

Let’s say you want aliases for Kubernetes:

```bash
touch ~/Code/dotfiles/zsh/k8s.zsh
```

```zsh
alias kctx='kubectl config use-context'
alias kpods='kubectl get pods'
```

Reload:

```bash
source ~/.zshrc
```

Done. You can even create `a.k8s` in `helpers.zsh` to list them like the others.

---

### Summary

This system:

* Prevents you from ever losing your config again
* Keeps everything modular and version-controlled
* Tracks your public logic while keeping secrets private
* Makes it easy to add/remove/configure tools in isolation
* Gives you discovery helpers like `a.aws`, `help`, etc.
* Can be bootstrapped in 3 minutes and extended forever

You don’t need to be a shell expert. You just need to follow structure.
And if something breaks, it only breaks one file — not your whole shell.

This is a developer-first blueprint for managing your ZSH like a system.

```

Would you like me to update your `dotmanz` repo automatically to include this and commit it under `docs: add automation.zsh and update readme`?
```
