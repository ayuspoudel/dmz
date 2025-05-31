use std::path::PathBuf;

pub fn get_local_zsh_dir() -> PathBuf {
    dirs::home_dir()
        .expect("Could not find home directory")
        .join(".dmz/zsh")
}

pub fn get_local_zshrc_path() -> PathBuf {
    dirs::home_dir()
        .expect("Could not find home directory")
        .join(".zshrc")
}
