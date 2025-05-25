## ZSH Automation

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

1. Copy this folder to somewhere in your home directory. I use:

```
~/Code/dotfiles/zsh/
```

2. Make sure your `.zshrc` file looks like this:

```zsh
ZSH_CONFIG="$HOME/Code/dotfiles/zsh"

for config_file in "$ZSH_CONFIG"/*.zsh; do
  source "$config_file"
done

[[ -f "$ZSH_CONFIG/private.zsh" ]] && source "$ZSH_CONFIG/private.zsh"
```

3. Save and reload your config:

```bash
source ~/.zshrc
```

That’s it.

---

### The intent behind each file

This is not a rulebook. These files are just a starting point. You can add more. Each file is self-contained.

#### aliases.zsh

All general-purpose aliases you use daily.
Things like jumping into directories (`cd` shortcuts), clearing the terminal, editing your config, etc.

#### aws.zsh

Shortcuts for interacting with AWS via the CLI.
This includes commands for EC2, S3, Lambda, IAM, ECR, and more.

You don’t need to remember long AWS CLI commands anymore. You create short aliases here.

#### docker.zsh

All Docker and Docker Compose commands go here.
No need to type `docker compose up -d` every time. Just type `dcu`.

#### dynatrace.zsh

This holds non-secret configuration like your Dynatrace environment URL.
Secrets like API tokens go in `private.zsh`.

#### git.zsh

Git and GitHub CLI aliases live here.
You can commit, push, create PRs, and more using just one-word shortcuts.

#### helpers.zsh

This is the most powerful file in the system.

It defines a special command called `alias_group`, and sets up aliases like:

* `a.aws` – shows all AWS-related aliases
* `a.git` – shows all Git-related aliases
* `a.terraform` – shows all Terraform-related aliases

You can also pass a keyword to filter:

* `a.aws ec2` – only shows aliases related to EC2
* `a.git push` – shows anything about Git pushing

You don’t have to remember what aliases you defined.
Just run `a.<group>` to list them clearly.

#### path.zsh

If you want to run your own scripts from anywhere, put them in `~/Code/bin/` and add that folder to your PATH. This file does that.

#### plugins.zsh

This loads extra tools like autosuggestions and syntax highlighting.
It checks if they are installed and only loads them if available.

No errors, no noise.

#### private.zsh

This file is **not tracked by Git**. It is ignored in `.gitignore`.

It is where you store sensitive values like API tokens or AWS profiles.

You do not share or publish this file.
You create it manually and use it safely.

#### prompt.zsh

This controls what your terminal looks like.
The prompt shows:

* Your username
* Hostname
* Folder name
* Git branch (if in a repo)
* The current time

You can modify it here without affecting anything else.

#### safety.zsh

This is your safety net.

It turns on:

* Interactive file deletion (so `rm` asks before deleting)
* Human-readable timestamps in your shell history
* Clean file viewing for binary formats

#### terraform.zsh

All Terraform-related aliases go here.
Includes basic commands (`terraform apply`) and useful workflows like:

```bash
tfcleanapply  # deletes the .terraform folder and reapplies fresh
```

---

### How to add more

Want to add aliases for Kubernetes?

1. Create a new file:

```
touch ~/Code/dotfiles/zsh/k8s.zsh
```

2. Add your content:

```zsh
alias kctx='kubectl config use-context'
alias kpods='kubectl get pods'
```

3. Reload:

```bash
source ~/.zshrc
```

Done.

There is **no need to change anything else**.
Your `.zshrc` already loads everything inside `zsh/` automatically.

You can add `a.k8s` in `helpers.zsh` to browse your new group just like the others.

---

### Summary

This setup:

* Prevents you from ever losing your config again
* Keeps everything organized in small, understandable files
* Lets you track everything in Git, except secrets
* Makes your terminal experience smooth, safe, and extensible
* Gives you tools (`a.aws`, `a.git`, `help`) to never forget what you created
* Lets you modify or extend anything in seconds

There is no learning curve. You don’t need to be a shell wizard.
If you want something, just drop it into its own file.

And if it ever breaks? It only breaks **that one file** — not your whole shell.

This is your personal blueprint. Use it as-is or grow it over time.
It will grow with you.
