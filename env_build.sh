#!/bin/bash 

source /sharedfs/spack/share/spack/setup-env.sh

spack load gcc@11.5.0
spack load mpich@4.2.3

export MPI_HOME=/sharedfs/spack/opt/spack/linux-debian11-broadwell/gcc-14.2.0/mpich-4.2.3-aaxa5ktovvlt5dizal7argu6ogibqifj
export CUDA_HOME=/usr/local/cuda

# Set location to store NCCL-PROFILE source/repository
NCCL_SRC_LOCATION="/sharedfs/nccl"
export NCCL_SRC_LOCATION
export NCCL_COMMIT="nccl_origin"

# Set location to store NCCL_TEST source/repository
NCCLTESTS_SRC_LOCATION="/sharedfs/nccl-tests"
export NCCLTESTS_SRC_LOCATION

export NVCC_GENCODE="-gencode=arch=compute_75,code=sm_75"

### NCCL-Section ###

# export PROFAPI=1
# Download NCCL
if [ ! -d "${NCCL_SRC_LOCATION}" ]; then
	echo "[INFO] Downloading NCCL repository..."
	git clone https://github.com/NVIDIA/nccl.git "${NCCL_SRC_LOCATION}"
elif [ -d "${NCCL_SRC_LOCATION}" ]; then 
	echo "[INFO] NCCL repository already exists."
fi
echo ""

# Enter NCCL dir
pushd "${NCCL_SRC_LOCATION}" || exit

# Build NCCL
echo "[INFO] Building NCCL..."
make clean
make -j src.build
echo ""

# Set environment variables that other tasks will use
echo "[INFO] Setting NCCL-related environment variables for other tasks..."
NCCL_HOME="${NCCL_SRC_LOCATION}/build" 
export NCCL_HOME
echo "[DEBUG] NCCL_HOME has been set to: ${NCCL_HOME}"

echo "[INFO] Updating LD_LIBRARY_PATH and PATH to include NCCL!"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${NCCL_HOME}/lib"
export LD_LIBRARY_PATH
PATH="${PATH}:${NCCL_HOME}/include"
export PATH
echo ""

# Exit NCCL dir
popd || exit
echo ""


### NCCL Tests Section ###

# Download NCCL Tests
if [ ! -d "${NCCLTESTS_SRC_LOCATION}" ]; then
	echo "[INFO] Downloading NCCL Tests repository..."
	git clone https://github.com/nvidia/nccl-tests.git "${NCCLTESTS_SRC_LOCATION}"
elif [ -d "${NCCLTESTS_SRC_LOCATION}" ]; then
	echo "[INFO] NCCL Tests repository already exists."
fi
echo ""

# Enter NCCL Tests dir
pushd "${NCCLTESTS_SRC_LOCATION}" || exit
echo ""
make clean

# Build NCCL Tests
echo "[INFO] Building NCCL tests (nccl-tests)"
make MPI=1 MPI_HOME=${MPI_HOME} CUDA_HOME=${CUDA_HOME} NCCL_HOME="${NCCL_SRC_LOCATION}/build"  


# make MPI=1 MPI_HOME=${MPI_HOME} CUDA_HOME=${CUDA_HOME} NCCL_HOME="${MSCCL_HOME}"

# Exit NCCL Tests dir
popd || exit
echo ""