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

There is
[an installer ISO](https://ci.centos.org/artifacts/sig-atomic/atomic-ws/images/installer/) available,
and it's been tested to work on bare metal. If you install inside a VM, see
[this known bug regarding libvirt + networking](https://bugzilla.redhat.com/show_bug.cgi?id=1146232).

Important issues:
-----------------------

 - [Anaconda autopartitoning](https://github.com/rhinstaller/anaconda/issues/800) - be sure to use `/var/home` instead of `/home`
 - [flatpak system repo](https://github.com/flatpak/flatpak/issues/113#issuecomment-247022006)
 
Using the system
--------------------

First, try out `rpm-ostree install` to layer additional packages.  For example,
`rpm-ostree install powerline`.

Next, try [oc cluster up](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md) to create a local OpenShift v3 cluster.

Another good way to work is to create "pet" Docker containers, and use `dnf/yum`
inside these.  You can use e.g. `-v /srv:/srv` so these containers can share
content with your host (such as git repositories).

Future work
-----------

 - GNOME Software support for both rpm-ostree/flatpak and possibly docker
 - ostree live updates for package layering
 - automated tests that run on this content
 
Related projects
-------------------

Here's
[a blog entry](http://dustymabe.com/2017/02/12/fedora-btrfssnapper-the-fedora-25-edition/) on
using dnf+snapper(btrfs) for host updates. This is an implementation
of
[client side snapshots](https://ostree.readthedocs.io/en/latest/manual/related-projects/).
What makes rpm-ostree better here is that the system is composed (and ideally
tested) server side.


