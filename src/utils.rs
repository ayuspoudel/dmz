use std::env;
use std::path::PathBuf;

pub fn install_root() -> PathBuf {
    dirs::home_dir()
        .expect("Could not find home directory")
        .join(".dotmanz")
}

pub fn get_local_zsh_dir() -> PathBuf {
    install_root().join("zsh")
}

pub fn get_local_zshrc_path() -> PathBuf {
    dirs::home_dir()
        .expect("Could not find home directory")
        .join(".zshrc")
}

pub fn install_root() -> PathBuf {
    if let Ok(path) = env::var("DOTMANZ_HOME") {
        return PathBuf::from(path);
    }
    dirs::home_dir().expect("Could not find home dir").join(".dotmanz")
}
