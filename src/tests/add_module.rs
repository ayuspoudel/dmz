use assert_fs::prelude::*;
use std::fs;

#[test]
fn it_creates_new_module_and_contains_header() {
    let temp = assert_fs::TempDir::new().unwrap();
    let test_path = temp.child("new_mod.zsh");

    crate::commands::add::scaffold_module(&test_path.path().to_path_buf(), "new_mod");

    test_path.assert(predicate::path::is_file());
    let contents = fs::read_to_string(test_path.path()).unwrap();
    assert!(contents.contains("ZSH Module: new_mod"));
}
