configdir=$(cd ~/workstation-ostree-config && pwd)
atomicwsdir=$(cd ~/atomic-ws && pwd)
build=atomic-ws
ref=fedora/26/x86_64/workstation
stable_ref_old=atomicws/fedora/x86_64/continuous
stable_ref=fedora/x86_64/workstation

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
    for d in ${configdir} ${atomicwsdir}; do
        (cd ${d} && git clean -dfx && git reset --hard HEAD)
    done

    cd ${WORKSPACE}
}

# Avoid recursion
if test -z "${WORKSPACE:-}"; then
    prepare_job
fi
