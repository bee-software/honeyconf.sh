#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if ! config "roles" | items | grep -q '^application_server$'; then
  exit 0
fi

cat <<EOF
# BEGIN: ensure_docker_running
if [ -f /lib/systemd/system/docker.service ]; then
  systemctl start docker.service
fi
# END: ensure_docker_running
EOF