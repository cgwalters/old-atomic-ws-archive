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

NEW! There is an installer ISO available, and it's been tested
to work on bare metal.  See:
https://ci.centos.org/artifacts/sig-atomic/fedora-workstation/images/installer/

Known issues:

 - After installation, you will need to edit `/etc/ostree/remotes.d/fedora.conf` and
   change `baseurl=https://ci.centos.org/artifacts/sig-atomic/fedora-workstation/ostree/repo/`.

Installing *inside* an existing system
---------------------------------------

A really neat feature of OSTree is that you can
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

**For EFI systems**: currently ostree uses the presence of /boot/grub2/grub.cfg to detect a BIOS system,
but that can be present on systems booted with EFI as well. If you boot with EFI
(/sys/firmware/efi exists), then you need to move /boot/grub2/grub.cfg aside:
```
mv /boot/grub2/grub.cfg /boot/grub2/grub.cfg.bak
```
Since this file is not used on a EFI system, this won't break the operation of your current system. While you are at it, back up your existing grub config:
```
cp /boot/efi/EFI/fedora/grub.cfg /boot/efi/EFI/fedora/grub.cfg.bak
```

Deploy; we use `enforcing=0` to avoid SELinux issues for now.
```
ostree admin deploy --os=fedora --karg-proc-cmdline --karg=enforcing=0 fedora-ws-centosci:fedora/24/x86_64/desktop/continuous
```

To initialize this root, you'll need to copy over your `/etc/fstab` and `/etc/default/grub` at least:
```
for i in /etc/fstab /etc/default/grub ; do cp $i /ostree/deploy/fedora/deploy/$checksum.0/$i; done
```
If you have a separate `/home` mount point, you'll need to change
that `fstab` copy to refer to `/var/home`.

**For BIOS systems**: while ostree regenerated the bootloader configuration,
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
