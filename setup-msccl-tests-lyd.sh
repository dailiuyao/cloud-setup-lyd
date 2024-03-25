#!/usr/bin/env bash

# Set up the script
set -e -x

# Configuration Variables
export NVCC_GENCODE="-gencode=arch=compute_90,code=sm_90"
export CUDA_HOME="/usr/local/cuda"
export NCCL_DIR="/mnt/sharedfs/ly-experiments/msccl"
export NCCL_TEST_DIR="/mnt/sharedfs/ly-experiments/msccl-test"
export NCCL_COMMIT="algorithm_test_CCLadviser"
export NCCL_TEST_COMMIT="nccl-test-profile-msccl"
export MPI_HOME="/opt/amazon/openmpi"

export TEMP_DIR="/tmp/inst-lyd"

# Update PATH so that correct versions of software are available
export PATH="/usr/local/bin:${CUDA_HOME}/bin:${MPI_HOME}/bin:${PATH}"

# Set up PATHs for CUDA
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${MPI_HOME}/lib64:${LD_LIBRARY_PATH}"
export C_INCLUDE_PATH="${CUDA_HOME}/include:${MPI_HOME}/include:$C_INCLUDE_PATH"

# Create a directory in tmp that we'll use during the setup process
mkdir -p "${TEMP_DIR}"

# Clone the NCCL repo if it doesn't already exist
if [ ! -d "${NCCL_DIR}" ]; then
    git clone https://github.com/dailiuyao/msccl-lyd.git "${NCCL_DIR}"
fi

# Move to the NCCL directory
pushd "${NCCL_DIR}" || exit

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



export NCCL_TEST_HOME="${NCCL_TEST_DIR}/build"

export NCCL_HOME="${NCCL_DIR}/build" 

# Set up PATHs for CUDA
export LD_LIBRARY_PATH="${NCCL_HOME}/lib:${LD_LIBRARY_PATH}"
export C_INCLUDE_PATH="${NCCL_HOME}/include:$C_INCLUDE_PATH"

# Create a directory in tmp that we'll use during the setup process
mkdir -p "${TEMP_DIR}"

# Clone the NCCL repo if it doesn't already exist
if [ ! -d "${NCCL_TEST_DIR}" ]; then
    git clone https://github.com/dailiuyao/nccl-tests.git "${NCCL_TEST_DIR}"
fi

# Move to the NCCL directory
pushd "${NCCL_TEST_DIR}" || exit

# Fetch latest changes
git fetch --all

# Checkout the correct commit
git checkout "${NCCL_TEST_COMMIT}"

# Build NCCL
make MPI=1


# Delete the directory in tmp
rm -rf "${TEMP_DIR}"

# Exit the NCCL directory
popd || exit
