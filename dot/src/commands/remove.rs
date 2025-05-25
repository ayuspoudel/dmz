use std::fs;
use std::path::PathBuf;
use colored::*;
use inquire::Select;

use crate::utils::get_local_zsh_dir;

pub fn run(module: &str) {
    println!(
        "{}\n{}\n",
        "WARNING:".red().bold(),
        "This command will permanently delete a ZSH module and all its aliases. Proceed with extreme caution.".red()
    );

    if module.is_empty() {
        run_interactive();
    } else {
        run_direct(module);
    }
}

fn run_direct(module: &str) {
    let path: PathBuf = get_local_zsh_dir().join(format!("{}.zsh", module));

    if !path.exists() {
        eprintln!(
            "{} {}",
            "Error:".red().bold(),
            format!("Module '{}' does not exist.", module).red()
        );
        return;
    }

    match fs::remove_file(&path) {
        Ok(_) => {
            println!(
                "{} {}",
                "Removed:".green().bold(),
                path.display()
            );
        }
        Err(err) => {
            eprintln!(
                "{} Failed to remove {}: {}",
                "Error:".red(),
                path.display(),
                err
            );
        }
    }
}

fn run_interactive() {
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
        println!("{}", "No modules available to remove.".yellow());
        return;
    }

    modules.sort();

    let selected = Select::new("Select a module to remove:", modules)
        .prompt()
        .expect("Prompt failed");

    run_direct(&selected);
}
