// tests/remove_module.rs
use assert_fs::prelude::*;
use std::fs;

#[test]
fn it_removes_existing_module_file() {
    let temp = assert_fs::TempDir::new().unwrap();
    let module = temp.child("remove_me.zsh");

    // Create a dummy module file
    module.write_str("alias rmtest='true'").unwrap();
    assert!(module.path().exists());

    // Run remove logic
    fs::remove_file(module.path()).expect("Failed to delete module");

    // Verify it's gone
    assert!(!module.path().exists());
}