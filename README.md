Development work on "Atomic Workstation"
--------------------------------------

For some background, see:

 - https://fedoraproject.org/wiki/Workstation/AtomicWorkstation
 - https://fedoraproject.org/wiki/Changes/WorkstationOstree

What this branch does implement a [Jenkins job](https://ci.centos.org/job/atomic-ws/) in
CentOS CI that combines baseline Fedora 25 content with [an overlay](overlay.yml)
of content that auto-builds packages from git of some key projects
like ostree/rpm-ostree.

High level design
-----------------

The goal of the system is to be a workstation, using
rpm-ostree for the base OS, and a combination of
Docker and Flatpak containers, as well as virtualization
tools such as Vagrant.

Status
------

This project is actively maintained and is ready for use
by sophisticated and interested users, but not ready
for widespread promotion.

Installing
----------

There is [an installer ISO](https://ci.centos.org/artifacts/sig-atomic/atomic-ws/images/installer/)
available, and it's been tested to work on bare metal.

Known issues:

 - [flatpak system repo](https://github.com/flatpak/flatpak/issues/113#issuecomment-247022006)
 - [Anaconda autopartitoning](https://github.com/rhinstaller/anaconda/issues/800) - be sure to use `/var/home` instead of `/home`
 - [Installing in libvirt + networking](https://bugzilla.redhat.com/show_bug.cgi?id=1146232)
 
OSTree remote:

```
[remote "atomic-ws"]
url=https://ci.centos.org/artifacts/sig-atomic/atomic-ws/ostree/repo/
gpg-verify=false
```

Branch: `atomicws/fedora/x86_64/continuous`

Installing *inside* an existing system
---------------------------------------

A really neat feature of OSTree is that you can
*parallel install* [inside your existing OS](docs/install-inside-existing.md).

Using
-----

To manipulate the host, try `rpm-ostree upgrade` and `rpm-ostree
install <package>`.

You will also likely want to try out using `docker` in a "pet
container" model, where you use yum/dnf inside the container for
development building and the like.  For example, create a CentOS
container with a bind mount on your `/srv` directory where you
store data (separate from your home directory).

`docker run -ti --privileged --name c7sh -v /var/srv:/srv centos`

From there, you can do things like `yum-builddep foo` or
and in general run development tools.

Future work
-----------

 - GNOME Software support for both rpm-ostree/flatpak and possibly docker
 - ostree live updates for package layering
 - automated tests that run on this content
