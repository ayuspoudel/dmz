// src/commands/add.rs
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use colored::*;
use inquire::{Select, Text};

use crate::utils::get_local_zsh_dir;
use crate::commands::refresh;

pub fn run(module: Option<&str>, should_refresh: bool) {
    match module {
        Some(name) => handle_named_add(name, should_refresh),
        None => handle_interactive_add(should_refresh),
    }
}  

fn handle_named_add(name: &str, should_refresh: bool) {
    let path = get_local_zsh_dir().join(format!("{}.zsh", name));

    if !path.exists() {
        println!("{} {}", "Creating new module:".blue(), name.green().bold());
        scaffold_module(&path, name);
    } else {
        println!("{} {}", "Opening existing module:".cyan(), name.green());
    }

    open_editor(&path, should_refresh);
}

fn handle_interactive_add(should_refresh: bool) {
    let zsh_dir = get_local_zsh_dir();

    if !zsh_dir.exists() {
        fs::create_dir_all(&zsh_dir).expect("Failed to create zsh folder");
    }

    let mut modules: Vec<String> = match fs::read_dir(&zsh_dir) {
        Ok(entries) => entries
            .flatten()
            .filter_map(|entry| {
                let path = entry.path();
                if path.extension()? == "zsh" {
                    path.file_stem()?.to_str().map(|s| s.to_string())
                } else {
                    None
                }
            })
            .collect(),
        Err(_) => vec![],
    };

    modules.sort();
    modules.push("➕ Create new module".to_string());

    let selected = Select::new("Select a module to edit:", modules)
        .prompt()
        .expect("Prompt failed");

    if selected == "➕ Create new module" {
        let name = Text::new("Enter new module name:")
            .prompt()
            .expect("Failed to read module name");

        let path = zsh_dir.join(format!("{}.zsh", name));

        if path.exists() {
            println!(
                "{} {}",
                "Notice:".yellow().bold(),
                format!("Module '{}' already exists.", name).yellow()
            );
        } else {
            scaffold_module(&path, &name);
        }

        open_editor(&path, should_refresh);
    } else {
        let path = zsh_dir.join(format!("{}.zsh", selected));
        open_editor(&path, should_refresh);
    }
}

fn scaffold_module(path: &PathBuf, name: &str) {
    let content = format!(
        r#"# -------------------------------
# ZSH Module: {}
# -------------------------------

# Add your aliases, exports, functions, etc. here

"#,
        name
    );

    fs::write(&path, content).expect("Failed to create module");
    println!("{} {}", "Created:".green().bold(), path.display());
}

fn open_editor(path: &Path, should_refresh: bool) {
    let editor = std::env::var("EDITOR").unwrap_or_else(|_| "vi".to_string());

    println!(
        "{}\n  {} {}\n",
        "Opening module in your editor...".cyan().bold(),
        "File:".blue(),
        path.display()
    );
    println!(
        "{}",
        "Tip: Make your changes, save the file, and close the editor to continue.".dimmed()
    );

    let mut cmd = Command::new(&editor);
    if editor.contains("code") || editor.contains("subl") || editor.contains("atom") {
        cmd.arg("--wait");
    }

    let status = cmd.arg(path).status().expect("Failed to launch editor");

    if status.success() {
        if should_refresh {
            refresh::run();
            println!("{} Run: source ~/.zshrc to apply changes", "➤".yellow());
        } else {
            println!("{} You must run 'dmz refresh' and 'source ~/.zshrc' to apply changes.", "⚠️".yellow());
        }
    } else {
        eprintln!("{} Failed to edit {}", "Error:".red(), path.display());
    }
}
