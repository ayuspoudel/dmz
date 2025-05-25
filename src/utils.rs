use std::env;
use std::path::PathBuf;

pub fn project_root() -> PathBuf {
    let exe_path = env::current_exe().expect("Failed to get current exe path");
    exe_path
        .parent()         // /target/debug/
        .and_then(|p| p.parent())   // /target/
        .and_then(|p| p.parent())   // /dotmanz/
        .map(|p| p.to_path_buf())
        .expect("Failed to resolve project root")
}

pub fn get_local_zsh_dir() -> PathBuf {
    project_root().join("zsh")
}

pub fn get_local_zshrc_path() -> PathBuf {
    project_root().join(".zshrc")
}
