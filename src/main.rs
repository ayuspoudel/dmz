mod cli;
mod commands;
mod utils;
mod constants;

use clap::Parser;
use cli::{Cli, Commands};

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Commands::List { verbose, module, filter } => {
            commands::list::run(*verbose, module.as_deref(), filter.as_deref());}
        Commands::Add { module } => commands::add::run(module.as_deref()),
        Commands::Remove { module } => {
            match module.as_deref() {
            Some(name) => commands::remove::run(name),
        None => commands::remove::run(""), // triggers interactive mode
        }
    },
        Commands::Refresh {} => commands::refresh::run(),
        Commands::Edit { module } => commands::edit::run(module.as_deref())

    }
    println!("ZSH folder: {}", utils::get_local_zsh_dir().display());
    println!("ZSHRC path: {}", utils::get_local_zshrc_path().display());

}
