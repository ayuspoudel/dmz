// tests/refresh_zshrc.rs
use assert_fs::prelude::*;
use std::fs;
use std::io::Write;
use predicates::prelude::*;
use std::path::PathBuf;

use dmz::utils::get_local_zshrc_path;

#[test]
fn it_updates_zshrc_with_loader_block() {
    // Setup fake HOME env
    let temp_home = assert_fs::TempDir::new().unwrap();
    std::env::set_var("HOME", temp_home.path());

    let zshrc_path = temp_home.child(".zshrc");
    let mut file = fs::File::create(zshrc_path.path()).unwrap();
    writeln!(file, "# Existing config\necho Hello").unwrap();

    // Run refresh
    dmz::commands::refresh::run();

    let contents = fs::read_to_string(zshrc_path.path()).unwrap();
    assert!(contents.contains("# dmz module loader"));
    assert!(contents.contains("for f in $HOME/.dmz/zsh/*.zsh"));
    assert!(contents.contains("echo Hello"));
}