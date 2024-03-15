#!/usr/bin/env bash

set -e -o pipefail

REMOTE_HOSTS=(52.88.202.159)  # Insert the IP of the remote machine here

LOCAL_USERNAME="liuyao" # Whatever your username is on your LOCAL COMPUTER, NOT THE REMOTE
LOCAL_GROUP="staff"   # If you're on MacOS, this will probably be `staff`
REMOTE_DIRECTORY="/home/ec2-user"
TMP_FS_DIR="/tmp/aws-full-filesystem"
OUTPUT_TAR_LOCATION="~/Downloads/aws-full-filesystem"

# Helper functions
error() {
  echo "$@" 1>&2
}

fail() {
  error "$@"
  exit 1
}

# Warnings and Info
echo "[WARNING] You may need to edit the script and use '-i' in the ssh portion of the rsync script if you have a specific SSH key you need to use. Contact Adam if you have questions or you're getting permission denied errors."

# Download for each remote host
# Note: You can pretty easily modify this script to download from _multiple_ machines.
for REMOTE_HOST in "${REMOTE_HOSTS[@]}"; do
	echo "[INFO] Downloading from ${REMOTE_HOST}..."

    rsync -e "ssh -i /Users/liuyaodai/.ssh/id_rsa_vir -o StrictHostKeyChecking=no" --rsync-path="sudo rsync" --chown=adam:staff --progress --stats -ruzath "ec2-user@${REMOTE_HOST}:${REMOTE_DIRECTORY}" "${TMP_FS_DIR}"

	echo "[INFO] Done."
done

# Make everything in the "filesystem" readable
chmod -R +r "${TMP_FS_DIR}"

# # Create an archive of the "filesystem"
# gtar --exclude=dev --exclude=proc --exclude=mnt --exclude=lost+found -cf - "${TMP_FS_DIR}" | zstd -T9 > "${OUTPUT_TAR_LOCATION}/aws-home-backup.tar.zst"
