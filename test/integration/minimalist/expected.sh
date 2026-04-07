#!/bin/bash
set -eu
ensure_apt_fresh() {
  if test -z "$(find /var/cache/apt/pkgcache.bin -mmin -60)"; then
    apt-get update -q
  fi
}

ensure_installed() {
  local packages=$*

  for package in $packages; do
    if ! dpkg -l $package | grep -q '^ii'; then
      ensure_apt_fresh
      DEBIAN_FRONTEND=noninteractive apt-get -y -q install $package
    fi
  done
}

halt_intervention_required() {
  echo "************************************************************"
  cat -
  echo "************************************************************"
  echo "PROCESS HALTED. Human intervention required"
  exit 101
}
# BEGIN: hostname
echo "test.example.com" > /etc/hostname
hostname test.example.com

grep '^127.0.1.1' /etc/hosts | grep -q 'test.example.com' || sed -i 's/^\(127.0.1.1\s.*\)/\1 test.example.com/g' /etc/hosts
# END: hostname
# BEGIN: ssh_authorized_keys
mkdir -p "/home/localadmin/.ssh"
cat <<EOF > /home/localadmin/.ssh/authorized_keys
#
# This file is managed by an automated provisioning task. Any manual change will eventually be overwritten.
#
ssh-rsa AAAAB3NzaC1yc2E your_key

EOF
chmod 644 /home/localadmin/.ssh/authorized_keys
# END: ssh_authorized_keys
# BEGIN: ensure_docker_running
if [ -f /lib/systemd/system/docker.service ]; then
  systemctl start docker.service
fi
# END: ensure_docker_running
# BEGIN: ssh_password_authentication
if ! grep -qi '^PasswordAuthentication no' /etc/ssh/sshd_config; then
  sed -i '/^PasswordAuthentication/Id' /etc/ssh/sshd_config
  echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
  systemctl reload ssh.service
fi
# END: ssh_password_authentication
# BEGIN: fail2ban
ensure_installed fail2ban
# END: fail2ban
# BEGIN: updatedb
if [ -f /etc/updatedb.conf ]; then
  . /etc/updatedb.conf
  if [ "$PRUNEPATHS" == "${PRUNEPATHS/\/mnt/}" ]; then
    sed -i '/PRUNEPATHS/c\PRUNEPATHS="'"$PRUNEPATHS /mnt"'"' /etc/updatedb.conf
  fi
  if [ "$PRUNEFS" == "${PRUNEFS/aufs/}" ]; then
    sed -i '/PRUNEFS/c\PRUNEFS="'"$PRUNEFS aufs"'"' /etc/updatedb.conf
  fi
fi
# END: updatedb
# BEGIN: application_server_role
if ! test -e /usr/bin/dockerd; then
  ensure_installed docker.io docker-compose-v2
fi
# END: application_server_role
