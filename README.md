Development work on "WorkstationOstree"
--------------------------------------

For some background, see:

https://fedoraproject.org/wiki/Changes/WorkstationOstree

What this branch does implement a [Jenkins job](https://ci.centos.org/job/atomic-fedora-ws/) in
CentOS CI that combines baseline Fedora 24 content with [an overlay](overlay.yml)
of content that auto-builds packages from git of some key projects
like ostree/rpm-ostree, as well as "stub" yum implementation to
avoid bringing in dnf.

Installing
----------

In the near future we'll generate an installer ISO and such.  But in
the short term, a really neat feature of OSTree is that you can
*parallel install* inside your existing OS.  Let's try that, we
first make sure we have the ostree packages:

```
yum -y install ostree ostree-grub2
```

Next, we add `/ostree/repo` to the filesystem:
```
ostree admin init-fs /
```

Add a remote which points to the CentOS CI content:
```
ostree remote add --set=gpg-verify=false fedora-ws-centosci https://ci.centos.org/artifacts/sig-atomic/rdgo/fedora-workstation/ostree/repo/
```

Pull down the content (you can interrupt and restart this):
```
ostree --repo=/ostree/repo pull fedora-ws-centosci:fedora/24/x86_64/desktop/continuous
```

Initialize an "os" for this, which acts as a state root.
```
ostree admin os-init fedora
```

Deploy; we use `enforcing=0` to avoid SELinux issues for now.
```
ostree admin deploy --os=fedora --karg-proc-cmdline --karg=enforcing=0 fedora-ws-centosci:fedora/24/x86_64/desktop/continuous
```

To initialize this root, you'll need to copy over your `/etc/fstab` at least:
```
cp /etc/fstab /ostree/deploy/fedora/deploy/$checksum.0/etc
```
If you have a separate `/home` mount point, you'll need to change
that `fstab` copy to refer to `/var/home`.

Finally, while ostree regenerated the bootloader configuration,
it writes config into `/boot/loader/grub.cfg`.  On a current `grubby`
system, you'll need to copy that version over:

```
cp /boot/loader/grub.cfg /boot/grub2/grub.cfg
```

Using
-----

Try `rpm-ostree upgrade` and `rpm-ostree pkg-add`.

Future work
-----------

 - Installer ISO
 - Verify we can do selinux enforcing
 - Document using "pet docker containers" with bind mounts
 - ostree live updates for package layering
 - automated tests that run on this content
