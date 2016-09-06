ostree_remote=atomicws-centsoci
ostree_repo=http://artifacts.ci.centos.org/sig-atomic/atomic-ws/ostree/repo
toolbox_base_args="-c ${buildscriptsdir}/config.ini --ostreerepo ${ostree_repo}"

prepare_image_build() {
    imgtype=$1

    # sudo since -toolbox might have leftover files as root if interrupted
    sudo rm build/${build}/images -rf
    mkdir -p build/${build}/images/${imgtype}
    cd build/${build}

    if ! test -d repo; then
	ostree --repo=repo init --mode=archive-z2
    fi
    ostree --repo=repo remote delete ${ostree_remote} || true
    ostree --repo=repo remote add --set=gpg-verify=false ${ostree_remote} ${ostree_repo}
    # https://github.com/ostreedev/ostree/issues/407
    ostree --repo=repo pull --mirror --disable-fsync --disable-static-deltas --depth=0 --commit-metadata-only ${ostree_remote} ${ref}

    rev=$(ostree --repo=repo rev-parse ${ref})
    version=$(ostree --repo=repo show --print-metadata-key=version ${ref} | sed -e "s,',,g")

    # Ensure we're operating on a clean base
    (cd ${buildscriptsdir} && git clean -dfx && git reset --hard HEAD)
    # Work around https://lists.centos.org/pipermail/ci-users/2016-July/000302.html
    for file in config.ini *.repo; do
	sed -i -e 's,https://ci.centos.org/artifacts/,http://artifacts.ci.centos.org/,g' ${buildscriptsdir}/${file}
    done

    cd images/${imgtype}
}

finish_image_build() {
    imgtype=$1
    sudo chown -R -h $USER:$USER ${version}
    ln -s ${version} latest
    cd ..
    rsync --delete --delete-after --stats -Hrlpt ${imgtype}/ sig-atomic@artifacts.ci.centos.org::sig-atomic/${build}/images/${imgtype}/
}
    
