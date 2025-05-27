use std::collections::HashSet;
use std::fs::{self, File};
use std::io::{BufRead, BufReader, Write};
use std::path::Path;
use chrono::Local;
use colored::*;
use inquire::{Confirm, Select};

pub fn run() {
    let home = dirs::home_dir().expect("Could not find home directory");
    let zshrc_path = home.join(".zshrc");
    let dotmanz_dir = home.join(".dotmanz/zsh");
    let migrated_dir = dotmanz_dir.join("migrated");

    let dry_run = Select::new("How do you want to run the migration?", vec!["Apply changes", "Dry run (just preview)"])
        .prompt()
        .map(|choice| choice == "Dry run (just preview)")
        .unwrap_or(false);

    fs::create_dir_all(&migrated_dir).expect("Failed to create .dotmanz/zsh directory");
    println!("{} Created {}", "✔".green(), dotmanz_dir.display());

    if zshrc_path.exists() && !dry_run {
        let timestamp = Local::now().format("%Y%m%d_%H%M%S");
        let backup_path = home.join(format!(".zshrc.dotmanz.bak.{}", timestamp));
        fs::copy(&zshrc_path, &backup_path).expect("Failed to back up .zshrc");
        println!("{} Backed up .zshrc to {}", "✔".green(), backup_path.display());
    }

    let file = File::open(&zshrc_path).expect("Unable to read .zshrc");
    let reader = BufReader::new(file);

    let mut seen_lines = HashSet::new();
    let mut aliases = Vec::new();
    let mut exports = Vec::new();
    let mut paths = Vec::new();
    let mut functions = Vec::new();
    let mut plugins = Vec::new();
    let mut misc = Vec::new();

    let mut in_function_block = false;
    let mut function_buffer = Vec::new();
    let mut brace_count = 0;

    for line in reader.lines().flatten() {
        if !seen_lines.insert(line.clone()) {
            println!("{} Skipped duplicate: {}", "⚠".yellow(), line);
            continue;
        }

        let trimmed = line.trim();

        if in_function_block {
            if trimmed.contains("{") {
                brace_count += trimmed.matches("{").count();
            }
            if trimmed.contains("}") {
                brace_count -= trimmed.matches("}").count();
            }
            function_buffer.push(line.clone());

            if brace_count == 0 {
                functions.extend(function_buffer.drain(..));
                in_function_block = false;
            }
            continue;
        }

        if trimmed.starts_with("alias ") {
            aliases.push(line.clone());
        } else if trimmed.starts_with("export PATH") {
            paths.push(line.clone());
        } else if trimmed.starts_with("export ") {
            exports.push(line.clone());
        } else if trimmed.starts_with("function ") || trimmed.ends_with("() {") || trimmed.ends_with("{") {
            in_function_block = true;
            brace_count = trimmed.matches("{").count() - trimmed.matches("}").count();
            function_buffer.push(line.clone());
        } else if trimmed.contains("oh-my-zsh") || trimmed.contains("zinit") || trimmed.contains("antigen") || trimmed.contains("plugin") {
            plugins.push(line.clone());
        } else {
            misc.push(line.clone());
        }
    }

    if dry_run {
        println!("\n{} DRY RUN: Here's what would be generated:", "📄".blue());
        show_module_summary("aliases.zsh", &aliases);
        show_module_summary("exports.zsh", &exports);
        show_module_summary("path.zsh", &paths);
        show_module_summary("plugins.zsh", &plugins);
        show_module_summary("functions.zsh", &functions);
        show_module_summary("migrated/misc.zsh", &misc);
        println!("\n{} Aborted: No files were written.", "ℹ".yellow());
        return;
    }

    write_module(&dotmanz_dir.join("aliases.zsh"), &aliases);
    write_module(&dotmanz_dir.join("exports.zsh"), &exports);
    write_module(&dotmanz_dir.join("path.zsh"), &paths);
    write_module(&dotmanz_dir.join("plugins.zsh"), &plugins);
    write_module(&dotmanz_dir.join("functions.zsh"), &functions);
    write_module(&migrated_dir.join("misc.zsh"), &misc);

    let preview = "# dotmanz managed zshrc\nfor f in $HOME/.dotmanz/zsh/**/*.zsh; do source \"$f\"; done\n\nfpath+=~/.zsh/completions\nautoload -Uz compinit && compinit";
    println!("\n{} Preview of new .zshrc:\n{}\n", "🔍".blue(), preview);

    let confirm = Confirm::new("Do you want to overwrite your .zshrc with this content?")
        .with_default(true)
        .prompt()
        .unwrap_or(false);

    if confirm {
        let mut new_zshrc = File::create(&zshrc_path).expect("Failed to overwrite .zshrc");
        writeln!(new_zshrc, "{}", preview).expect("Failed to write to .zshrc");

        println!("{} .zshrc is now managed by dotmanz.", "✔".green());
        println!("{} Run: {}", "➡", "source ~/.zshrc".yellow());
    } else {
        println!("{} Aborted: .zshrc was not modified.", "⚠".yellow());
    }
}

fn write_module(path: &Path, lines: &[String]) {
    if lines.is_empty() { return; }
    let mut file = File::create(path).expect("Failed to create module file");
    for line in lines {
        writeln!(file, "{}", line).expect("Failed to write to module");
    }
    println!("{} Created module: {}", "✔".green(), path.display());
}

fn show_module_summary(name: &str, lines: &[String]) {
    println!("\n>> {} ({} lines)", name.blue().bold(), lines.len());
    for line in lines.iter().take(5) {
        println!("  {}", line);
    }
    if lines.len() > 5 {
        println!("  {}", "...".dimmed());
    }
}
