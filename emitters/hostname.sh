#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if [ "$(config "options.manage_hostname" | default "true")" != "true" ]; then
  exit 0
fi

cat <<EOF
# BEGIN: hostname
echo "${MACHINE_NAME}" > /etc/hostname
hostname ${MACHINE_NAME}

grep '^127.0.1.1' /etc/hosts | grep -q '${MACHINE_NAME}' || sed -i 's/^\(127.0.1.1\s.*\)/\1 ${MACHINE_NAME}/g' /etc/hosts
# END: hostname
EOF
