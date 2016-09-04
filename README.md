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
*parallel install* [inside your existing OS](docs/install-inside-existing.md).

Using
-----

Try `rpm-ostree upgrade` and `rpm-ostree pkg-add`.

You will also likely want to try out using `docker` in a "pet
container" model, where you use yum/dnf inside the container for
development building and the like.  For example, create a CentOS
container with a bind mount on your `/srv` directory where you
store data (separate from your home directory).

`docker run -ti --privileged --name c7sh -v /var/srv:/srv centos`

Future work
-----------

 - Document using "pet docker containers" with bind mounts
 - ostree live updates for package layering
 - automated tests that run on this content
