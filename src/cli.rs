use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "dotmanz", version)]
#[command(about = "Manage your modular ZSH setup", long_about = None)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// List available modules
    List {
        /// Show contents of each module
        #[arg(short, long)]
        verbose: bool,

        /// Show only this specific module
        module: Option<String>,

        /// Filter lines by keyword inside the module
        #[arg(short= 'f', long = "filter")]
        filter: Option<String>,
    },

    /// Add a module to .zshrc
    Add {
        #[arg(long)]
        no_refresh: bool,
        module: Option<String>,
    },

    /// Remove a module from .zshrc
    Remove { module: Option<String> },

    /// Reinitialize .zshrc with all modules
    Refresh,
    Edit{ module: Option<String> },
    Completions {
        /// The shell type to generate for (e.g. zsh, bash, fish)
        #[arg(value_enum)]
        shell: clap_complete::Shell,
    },
    Version,
}
