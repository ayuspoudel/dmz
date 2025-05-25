use std::fs;
use colored::*;
use crate::utils::get_local_zsh_dir;

pub fn run(verbose: bool, module: Option<&str>, filter: Option<&str>)
 {
    let zsh_dir = get_local_zsh_dir();

    if !zsh_dir.exists() {
        eprintln!(
            "{} {}",
            "Error:".red().bold(),
            format!("zsh folder not found at {}", zsh_dir.display()).red()
        );
        return;
    }

    match module {
        Some(name) => {
    let file_path = zsh_dir.join(format!("{}.zsh", name));
    if !file_path.exists() {
        eprintln!("{} {}", "Module not found:".red().bold(), name.red());
        return;
    }

    println!("{} {}\n", "Module:".blue().bold(), name.green().bold());

    let content = match fs::read_to_string(&file_path) {
        Ok(c) => c,
        Err(err) => {
            eprintln!("{} {}", "Error reading file:".red(), err);
            return;
        }
    };

    let aliases: Vec<(String, String)> = content
    .lines()
    .filter_map(|line| {
        line.trim()
            .strip_prefix("alias ")
            .and_then(|s| s.split_once('='))
            .map(|(n, v)| (n.trim().to_string(), v.trim_matches(&['\'', '"'][..]).to_string()))
    })
    .filter(|(name, val)| {
        if let Some(filter_str) = filter {
            name.contains(filter_str) || val.contains(filter_str)
        } else {
            true
        }
    })
    .collect();


    if aliases.is_empty() {
        println!("{}", "(no aliases found)".yellow());
        return;
    }

    println!("{}", "Aliases:".cyan().bold());

    // Determine max width for alignment
    let max_len = aliases.iter().map(|(name, _)| name.len()).max().unwrap_or(0);

    for (name, value) in aliases {
        println!(
            "  {:width$} {} {}",
            name.green().bold(),
            "→".dimmed(),
            value.bright_black(),
            width = max_len
        );
    }
}

        None => {
            println!("{}", "Available ZSH modules:".blue().bold());

            let entries = match fs::read_dir(&zsh_dir) {
                Ok(e) => e,
                Err(err) => {
                    eprintln!("{} {}", "Error:".red(), err);
                    return;
                }
            };

            let mut found = false;

            for entry in entries.flatten() {
                let path = entry.path();
                if path.extension().map_or(false, |ext| ext == "zsh") {
                    if let Some(name) = path.file_stem() {
                        println!("  {}", name.to_string_lossy().green());
                        if verbose {
                            match fs::read_to_string(&path) {
                                Ok(content) => println!("{}", content.bright_black()),
                                Err(_) => println!("  {}", "(failed to read file)".red()),
                            }
                            println!(); // spacing
                        }
                        found = true;
                    }
                }
            }

            if !found {
                println!("{}", "(no modules found)".yellow());
            }
        }
    }
}
