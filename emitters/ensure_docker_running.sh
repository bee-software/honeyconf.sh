#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if [ "$(config "options.manage_docker" | default "true")" != "true" ]; then
  exit 0
fi

cat <<EOF
# BEGIN: ensure_docker_running
if [ -f /lib/systemd/system/docker.service ]; then
  systemctl start docker.service
fi
# END: ensure_docker_running
EOF