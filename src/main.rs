mod cli;
mod commands;
mod utils;
mod constants;

use clap::Parser;
use cli::{Cli, Commands};
use clap::CommandFactory;

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Commands::List { verbose, module, filter } => {
            commands::list::run(*verbose, module.as_deref(), filter.as_deref());
        }
        Commands::Add { module, no_refresh } => {
            commands::add::run(module.as_deref(), !no_refresh);
        }
        Commands::Remove { module } => {
            match module.as_deref() {
                Some(name) => commands::remove::run(name),
                None => commands::remove::run(""),
            }
        }
        Commands::Refresh => {
            commands::refresh::run();
        }
        Commands::Edit { module } => {
            commands::edit::run(module.as_deref());
        }
        Commands::Version => {
            println!(
                "\x1b[1;33mdmz version:\x1b[0m {}",
                env!("CARGO_PKG_VERSION")
            );
        }
        Commands::Completions { shell } => {
            let mut cmd = Cli::command();
            let name = cmd.get_name().to_string();
            clap_complete::generate(*shell, &mut cmd, name, &mut std::io::stdout());
        }
        Commands::Init => {
            commands::init::run();
        }
    }
}
