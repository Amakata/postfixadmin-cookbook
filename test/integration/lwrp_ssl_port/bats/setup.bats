#!/usr/bin/env bats

@test "setup.php returns that everything is fine" {
  curl -Lk 'https://localhost:8443/setup.php' | grep -qF 'Everything seems fine'
}

@test "setup.php creates the database" {
  curl -Lk 'https://localhost:8443/setup.php' | grep -qF 'Database is up to date'
}
