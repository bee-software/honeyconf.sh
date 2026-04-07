#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if [ "$(config "options.manage_fail2ban" | default "true")" != "true" ]; then
  exit 0
fi

cat <<EOF
# BEGIN: fail2ban
ensure_installed fail2ban
# END: fail2ban
EOF