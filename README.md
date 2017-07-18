This repository has moved/changed
--------------------------------------

Content generation is now in Fedora itself, for Fedora 26
and rawhide.  New content:

https://pagure.io/workstation-ostree-config

Rebasing an existing system is:

```
ostree remote add --if-not-exists --gpg-import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-26-primary fedora-ws-26 https://kojipkgs.fedoraproject.org/compose/ostree/26
pm-ostree rebase fedora-ws-26:fedora/26/x86_64/workstation
```
