use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

use colored::*;
use inquire::Select;

use crate::utils::get_local_zsh_dir;
use crate::commands::refresh;

pub fn run(module: Option<&str>)
 {
    match module {
        Some(name) => handle_direct_edit(name),
        None => handle_interactive_edit(),
    }
}

fn handle_direct_edit(name: &str) {
    let path = get_local_zsh_dir().join(format!("{}.zsh", name));

    if !path.exists() {
        eprintln!(
            "{} {}",
            "Error:".red().bold(),
            format!("Module '{}' does not exist.", name).red()
        );
        return;
    }

    open_editor(&path);
}

fn handle_interactive_edit() {
    let zsh_dir = get_local_zsh_dir();

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

    if modules.is_empty() {
        println!("{}", "No modules available to edit.".yellow());
        return;
    }

    modules.sort();

    let selected = Select::new("Select a module to edit:", modules)
        .prompt()
        .expect("Prompt failed");

    let path = zsh_dir.join(format!("{}.zsh", selected));
    open_editor(&path);
}

fn open_editor(path: &Path) {
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
        refresh::run();
    } else {
        eprintln!("{} Failed to edit {}", "Error:".red(), path.display());
    }
}
