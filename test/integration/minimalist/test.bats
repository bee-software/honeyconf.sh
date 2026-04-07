#!/usr/bin/env bats
load ../../common.sh
@test "produces expected output" {
  cat "$BATS_TEST_DIRNAME/machines.yaml" | create_machines_yaml

  compile 'test.example.com'
  assert_successful

  cat "$BATS_TEST_DIRNAME/expected.sh" | assert_output
}
