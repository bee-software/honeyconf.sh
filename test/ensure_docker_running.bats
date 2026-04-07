#!/usr/bin/env bats
load common.sh

@test "ensures docker is running for application servers" {
  create_machines_yaml <<MACHINES_YAML
machines:
  test.example.com: {}
MACHINES_YAML
  compile 'test.example.com'
  assert_successful

  assert_output_matching '/^# BEGIN: ensure_docker_running$/,/^# END: ensure_docker_running$/' <<EXPECTED
if [ -f /lib/systemd/system/docker.service ]; then
  systemctl start docker.service
fi
EXPECTED
}

@test "does not emit any statement when unconfigured" {
  create_machines_yaml <<MACHINES_YAML
machines:
  test.example.com:
    options:
      manage_docker: false
MACHINES_YAML
  compile 'test.example.com'
  assert_successful

  assert_output_does_not_contain 'ensure_docker_running'
}