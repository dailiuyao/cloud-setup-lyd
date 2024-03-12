#!/usr/bin/env bash
 
# Set up the script
set -e -x
 
# Configuration Variables
export CUDA_HOME="/usr/local/cuda"
export MSCCLTESTS_HOME="/home/ec2-user/deps/msccl-tests-lyd"
export MSCCLTESTS_COMMIT="nccl-test-profile-msccl"
 
export EFA_HOME="/opt/amazon/efa"
export MPI_HOME="/opt/amazon/openmpi"
export TEMP_DIR="/tmp/msccl-tests-inst"
export NCCL_HOME="/home/ec2-user/deps/msccl/build"  # In this case, we're using MSCCL
 
# Update PATH so that correct versions of software are available
export PATH="/usr/local/bin:${PATH}"
 
# Set up PATHs for CUDA, MPI, and NCCL
export PATH="${CUDA_HOME}/bin:${MPI_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${EFA_HOME}/lib:${EFA_HOME}/lib64:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="${NCCL_HOME}/include:${NCCL_HOME}/lib:${MPI_HOME}/include:${MPI_HOME}/lib:${CUDA_HOME}/include:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"
 
# Create a directory in tmp that we'll use during the setup process
mkdir -p "${TEMP_DIR}"
 
# Clone the NCCL-tests repo if it doesn't already exist
if [ ! -d "${MSCCLTESTS_HOME}" ]; then
    git clone https://github.com/dailiuyao/nccl-tests.git "${MSCCLTESTS_HOME}"
fi
 
# Move to the NCCL-tests directory
pushd "${MSCCLTESTS_HOME}" || exit

 
# Fetch latest changes
git fetch --all
#
# Checkout the correct commit
git checkout "${MSCCLTESTS_COMMIT}"
 
# Build NCCL
make -j MPI=1
 
# Delete the directory in tmp
rm -rf "${TEMP_DIR}"
 
# Exit the NCCL directory
popd || exit
