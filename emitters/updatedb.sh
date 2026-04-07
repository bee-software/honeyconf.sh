#!/bin/bash -eu
pushd "$(dirname $0)" > /dev/null
. ../config.sh
popd > /dev/null

if [ "$(config "options.manage_updatedb" | default "true")" != "true" ]; then
  exit 0
fi

cat <<"EOF"
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
EOF
