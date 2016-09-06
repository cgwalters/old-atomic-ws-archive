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

To initialize this root, you'll need to copy over your `/etc/fstab` and `/etc/default/grub` at least, along with the ostree remote that we added:
```
for i in /etc/fstab /etc/default/grub /etc/ostree/remotes.d/fedora-ws-centosci.conf ; do cp $i /ostree/deploy/fedora/deploy/$checksum.0/$i; done
```
If you have a separate `/home` mount point, you'll need to change
that `fstab` copy to refer to `/var/home`.

You'll also need to copy your user entry from `/etc/passwd`, `/etc/group`,
and `/etc/shadow` into the new `/etc/`, and add yourself to the wheel group
in `/etc/group`. Don't copy just copy these files literally, however, since
the system users and groups won't be the same.

**For BIOS systems**: while ostree regenerated the bootloader configuration,
it writes config into `/boot/loader/grub.cfg`.  On a current `grubby`
system, you'll need to copy that version over:

```
cp /boot/loader/grub.cfg /boot/grub2/grub.cfg
```
