#!/usr/bin/env bats

@test "setup.php should return that everything is fine" {
  curl -Lk 'localhost/setup.php' | grep -qF 'Everything seems fine'
}

@test "setup.php should create the database" {
  curl -Lk 'localhost/setup.php' | grep -qF 'Database is up to date'
}
