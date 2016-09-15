buildscriptsdir=$(cd ~/atomic-ws && pwd)
build=atomic-ws
OSTREE_BRANCH=${OSTREE_BRANCH:-continuous}
ref=atomicws/fedora/x86_64/${OSTREE_BRANCH}

prepare_job() {
    export WORKSPACE=$HOME/jobs/${JENKINS_JOB_NAME}
    sudo rm ${WORKSPACE} -rf
    mkdir -p ${WORKSPACE}

    export CACHEDIR=$HOME/cache
    mkdir -p ${CACHEDIR}

    export BUILD_LOGS=$HOME/build-logs
    rm ${BUILD_LOGS} -rf
    mkdir ${BUILD_LOGS}

    . ~/rsync-password.sh 

    # Ensure we're operating on a clean base
    (cd ${buildscriptsdir} && git clean -dfx && git reset --hard HEAD)

    # Ensure we're operating on a clean base
    (cd ${buildscriptsdir} && git clean -dfx && git reset --hard HEAD)
    # Work around https://lists.centos.org/pipermail/ci-users/2016-July/000302.html
    for file in config.ini *.repo; do
	sed -i -e 's,https://ci.centos.org/artifacts/,http://artifacts.ci.centos.org/,g' ${buildscriptsdir}/${file}
    done

    sed -i -e 's,^ref *=.*,ref = '${ref}',' ${buildscriptsdir}/config.ini
    grep '^ref =' ${buildscriptsdir}/config.ini

    cd ${WORKSPACE}
}

# Avoid recursion
if test -z "${WORKSPACE:-}"; then
    prepare_job
fi
