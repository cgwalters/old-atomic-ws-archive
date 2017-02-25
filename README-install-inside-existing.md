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
