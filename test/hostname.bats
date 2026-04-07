#!/usr/bin/env bats
load common.sh

@test "configures hostname by default" {
  create_machines_yaml <<MACHINES_YAML
machines:
  test.example.com: {}
MACHINES_YAML
  compile 'test.example.com'
  assert_successful

  assert_output_matching '/^# BEGIN: hostname$/,/^# END: hostname$/' <<EXPECTED
echo "test.example.com" > /etc/hostname
hostname test.example.com

grep '^127.0.1.1' /etc/hosts | grep -q 'test.example.com' || sed -i 's/^\(127.0.1.1\s.*\)/\1 test.example.com/g' /etc/hosts
EXPECTED
}

@test "configures hostname when specified" {
  create_machines_yaml <<MACHINES_YAML
machines:
  test.example.com:
    options:
      manage_hostname: true
MACHINES_YAML
  compile 'test.example.com'
  assert_successful

  assert_output_matching '/^# BEGIN: hostname$/,/^# END: hostname$/' <<EXPECTED
echo "test.example.com" > /etc/hostname
hostname test.example.com

grep '^127.0.1.1' /etc/hosts | grep -q 'test.example.com' || sed -i 's/^\(127.0.1.1\s.*\)/\1 test.example.com/g' /etc/hosts
EXPECTED
}

@test "does not emit any statement when unconfigured" {
  create_machines_yaml <<MACHINES_YAML
machines:
  test.example.com:
    options:
      manage_hostname: false
MACHINES_YAML
  compile 'test.example.com'
  assert_successful

  assert_output_does_not_contain 'hostname'
}