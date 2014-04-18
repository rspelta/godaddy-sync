#!/bin/bash
#
# daddu-sync.sh [password] [destination folder]

if [ $# -eq 2 ]
then
    PASSWORD=${1}
    LOCAL_ROOT=${2}
else
    PASSWORD=`zenity --password`
    LOCAL_ROOT=`zenity --entry --text "Path of destination"`
fi

function exit_error()
{
    echo "ERROR"
    exit 1
}


function rsync_commonboard_godaddy()
{
    REMOTE_DIR=${1}
    LOCAL_DIR=${1}
    echo -n "${LOCAL_DIR}..."
    mkdir -p ${LOCAL_DIR}
    sshpass -p ${PASSWORD} rsync -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/ ${LOCAL_ROOT}/${LOCAL_DIR}
    [ $? -eq 0 ] || { exit_error; }
    echo "OK"
}

function rsync_pengwy_godaddy()
{
    echo -n "pengwyn..."
    REMOTE_DIR="pengwyn"
    LOCAL_DIR="pengwyn"
    mkdir -p ${LOCAL_DIR}/script
    sshpass -p ${PASSWORD} rsync -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/script
    [ $? -eq 0 ] || { exit_error; }
    mkdir -p ${LOCAL_DIR}/sdk
    sshpass -p ${PASSWORD} rsync -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/sdk
    [ $? -eq 0 ] || { exit_error; }
    mkdir -p ${LOCAL_DIR}/toolchain
    sshpass -p ${PASSWORD} rsync -e ssh -az --delete-after b8800814@www.rsr-solutions.net:html/architech/${REMOTE_DIR}/script/ ${LOCAL_ROOT}/${LOCAL_DIR}/toolchain
    [ $? -eq 0 ] || { exit_error; }
	echo "OK"
}

echo "start, save in ${LOCAL_ROOT}"


rsync_commonboard_godaddy "hachiko"
rsync_commonboard_godaddy "hachiko-tiny"
rsync_commonboard_godaddy "tibidabo"
rsync_commonboard_godaddy "zedboard"
rsync_pengwy_godaddy

echo "end success"

exit 0

