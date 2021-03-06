#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null


display_usage() { 
    echo "Usage: $0 <project>"

    echo -e "\nAvailable projects:"
    for f in ${SCRIPTPATH}/projects/*; do
        if [[ -d $f ]]; then
            echo -e "\t- $(basename $f)"
        fi
    done
} 

PROJECT=$1

if [ "$1" == "" ] || [ ! -d ${SCRIPTPATH}/projects/$1 ]; then
    display_usage
    exit 1
fi

mkdir -p ${SCRIPTPATH}/build/${PROJECT}
pushd ${SCRIPTPATH}/build/${PROJECT}

export USE_OOC_SYNTHESIS=1

vivado -mode tcl -source ${SCRIPTPATH}/projects/${PROJECT}/create_project.tcl << EOF
project_run ${PROJECT}
close_project
exit
EOF

popd
