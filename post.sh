#!/bin/bash

set -xeuo pipefail

# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1265295
echo 'Storage=persistent' >> /etc/systemd/journald.conf

# Work around https://github.com/systemd/systemd/issues/4082
find /usr/lib/systemd/system/ -type f -exec sed -i -e '/^PrivateTmp=/d' -e '/^Protect\(Home\|System\)=/d' {} \;

# Docker initialization to use overlayfs (and disable selinux for now)
dockerconf=/etc/sysconfig/docker
OPTIONS="$(grep -e '^OPTIONS=' ${dockerconf} | sed -e 's,^OPTIONS=,,' | sed -e 's,--selinux-enabled,,') --storage-driver=overlay2"
sed -e 's,^OPTIONS=,OPTIONS='"${OPTIONS}"',' < ${dockerconf} > ${dockerconf}.new
mv ${dockerconf}{.new,}
# Not needed with overlayfs
systemctl mask docker-storage-setup
