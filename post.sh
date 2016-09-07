#!/bin/bash

set -xeuo pipefail

# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1265295
echo 'Storage=persistent' >> /etc/systemd/journald.conf

# Work around https://github.com/systemd/systemd/issues/4082
find /usr/lib/systemd/system/ -type f -exec sed -i -e '/^PrivateTmp=/d' -e '/^Protect\(Home\|System\)=/d' {} \;

# Docker initialization to use overlayfs (and disable selinux for now)
echo 'STORAGE_DRIVER=overlay' >> /etc/sysconfig/docker-storage-setup
