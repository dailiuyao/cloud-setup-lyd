#!/usr/bin/env bash

# Set up the script
set -e -x

# Configuration Variables
export NVCC_GENCODE="-gencode=arch=compute_90,code=sm_90"
export CUDA_HOME="/usr/local/cuda"
export NCCL_HOME="/opt/nccl-lyd"
export NCCL_COMMIT="nccl_tree"

export TEMP_DIR="/tmp/nccl-inst-lyd"

# Update PATH so that correct versions of software are available
export PATH="/usr/local/bin:${CUDA_HOME}/bin:${PATH}"

# Set up PATHs for CUDA
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_HOME}/include:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"

# Create a directory in tmp that we'll use during the setup process
mkdir -p "${TEMP_DIR}"

# Clone the NCCL repo if it doesn't already exist
if [ ! -d "${NCCL_HOME}" ]; then
    git clone https://github.com/dailiuyao/NCCL_profile.git "${NCCL_HOME}"
fi

# Move to the NCCL directory
pushd "${NCCL_HOME}" || exit

# Fetch latest changes
git fetch --all

# Checkout the correct commit
git checkout "${NCCL_COMMIT}"

# Build NCCL
make -j src.build

# Delete the directory in tmp
rm -rf "${TEMP_DIR}"

# Exit the NCCL directory
popd || exit
