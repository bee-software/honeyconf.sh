#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if [ "$(config "options.disable_ssh_password_authentication" | default "true")" != "true" ]; then
  exit 0
fi

cat <<EOF
# BEGIN: ssh_password_authentication
if ! grep -qi '^PasswordAuthentication no' /etc/ssh/sshd_config; then
  sed -i '/^PasswordAuthentication/Id' /etc/ssh/sshd_config
  echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
  systemctl reload ssh.service
fi
# END: ssh_password_authentication
EOF