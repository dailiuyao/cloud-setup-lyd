#!/bin/bash

export SHARED_HOME_DIRECTORY=/sharedfs

source /sharedfs/spack/share/spack/setup-env.sh

spack load gcc@11.5.0
spack load mpich@4.2.3

export MPI_HOME=/sharedfs/spack/opt/spack/linux-debian11-broadwell/gcc-14.2.0/mpich-4.2.3-aaxa5ktovvlt5dizal7argu6ogibqifj
export PATH="${MPI_HOME}/bin:$PATH"
export LD_LIBRARY_PATH="${MPI_HOME}/lib:$LD_LIBRARY_PATH"
export CUDA_HOME=/usr/local/cuda

export NCCL_NET_PLUGIN_HOME=${SHARED_HOME_DIRECTORY}/nccl-fastsocket
export LD_LIBRARY_PATH=${SHARED_HOME_DIRECTORY}/nccl-fastsocket/bazel-bin:$LD_LIBRARY_PATH

NCCL_SRC_LOCATION="/sharedfs/nccl"
export NCCL_SRC_LOCATION
NCCL_HOME="${NCCL_SRC_LOCATION}/build" 
export NCCL_HOME

NCCLTESTS_SRC_LOCATION="/sharedfs/nccl-tests"
export NCCLTESTS_SRC_LOCATION

export NVCC_GENCODE="-gencode=arch=compute_75,code=sm_75"

LD_LIBRARY_PATH="${NCCL_HOME}/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH
PATH="${NCCL_HOME}/include:${PATH}"
export PATH

node01=35.230.3.106
node02=34.168.35.180

echo $node01,$node02

export NCCL_DEBUG=INFO
export NCCL_PROTO=Simple

# Using an inline script to handle ranks with MPICH
mpirun -np 2 -host $node01,$node02 -ppn 1 \
    bash -c '
    rank=$(printenv PMI_RANK);  # MPICH environment variable for rank
    ${NCCLTESTS_SRC_LOCATION}/build/all_reduce_perf -b 128 -e 32MB -f 2 -g 2 -c 1 -n 100 -w 100 -G 100 -z 0 \
    >> /sharedfs/nccl-test-${rank}.out 2>&1
    '