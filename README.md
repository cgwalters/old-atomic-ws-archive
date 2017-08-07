This repository has moved/changed
--------------------------------------

The goal is to merge this project into Fedora.  Content
definition now lives in:

https://pagure.io/workstation-ostree-config

However, currently Fedora is not shipping updates.  This
project fills that gap temporarily by generating updated
OSTree commits in the CentOS CI infrastructure.

```
ostree remote add --if-not-exists --set=gpg-verify=false atomicws https://ci.centos.org/artifacts/sig-atomic/atomic-ws/ostree/repo
rpm-ostree rebase atomicws:fedora/x86_64/workstation
```
