use std::fs;
use std::io::Write;
use crate::utils::get_local_zshrc_path;

const HEADER_LINE: &str = "# dmz module loader";
const SOURCE_LINE: &str = r#"for f in $HOME/.dmz/zsh/*.zsh; do source "$f"; done"#;

const GREEN: &str = "\x1b[0;32m";
const YELLOW: &str = "\x1b[1;33m";
const RED: &str = "\x1b[0;31m";
const RESET: &str = "\x1b[0m";

pub fn run() {
    let zshrc_path = get_local_zshrc_path();

    // Read .zshrc or create empty
    let original = fs::read_to_string(&zshrc_path).unwrap_or_default();

    // Filter out old dmz loader lines
    let mut lines: Vec<String> = original
        .lines()
        .filter(|line| {
            !line.trim().starts_with(HEADER_LINE) &&
            !line.trim().starts_with("for f in $HOME/.dmz/zsh")
        })
        .map(|s| s.to_string())
        .collect();

    // Append fresh loader block
    lines.push("\n".to_string());
    lines.push(HEADER_LINE.to_string());
    lines.push(SOURCE_LINE.to_string());

    // Write back
    match fs::File::create(&zshrc_path) {
        Ok(mut file) => {
            for line in lines {
                let _ = writeln!(file, "{}", line);
            }

            println!("{GREEN}Refreshed:{RESET} ZSH module state updated.");
            println!("{YELLOW}ZSH folder:{RESET} {}", std::env::var("HOME").unwrap() + "/.dmz/zsh");
            println!("{YELLOW}ZSHRC path:{RESET} {}", zshrc_path.display());
        }
        Err(e) => {
            eprintln!("{RED}Error:{RESET} Failed to write to {} — {}", zshrc_path.display(), e);
        }
    }
}
