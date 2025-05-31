// tests/integration_list.rs
use assert_cmd::Command;
use predicates::str::contains;

#[test]
fn dmz_list_prints_modules() {
    let mut cmd = Command::cargo_bin("dmz").unwrap();
    cmd.arg("list")
        .assert()
        .success()
        .stdout(contains("ZSH folder:"));
}
