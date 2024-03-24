#!/bin/bash

export SCRIPT_LYD_HOME=/home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd

export NCCL_HOME="/opt/nccl"

export MSCCL_HOME="/home/ec2-user/deps/msccl"

# mpirun --hostfile ~/hostfile --map-by ppr:1:node mkdir -p /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/nccl

# mpirun --hostfile ~/hostfile --map-by ppr:1:node mkdir -p /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/msccl

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/opt/nccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/opt/nccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="TREE" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/nccl/nccl_all_reduce_tree.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/opt/nccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/opt/nccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="RING" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/nccl/nccl_all_reduce_ring.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/home/ec2-user/deps/msccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/home/ec2-user/deps/msccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="MSCCL,TREE,RING" \
    -x MSCCL_XML_FILES="/home/ec2-user/deps/msccl-tools-lyd/examples/xml/xml_lyd/aws-test/8nic/16gpus/allreduce_binary_tree_node2_gpu16_mcl8_mck128_gan0.xml" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/msccl/all-reduce_sum_float_binary-tree_node2_gpu16_mcl8_mck128_i0.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/home/ec2-user/deps/msccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/home/ec2-user/deps/msccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="MSCCL,TREE,RING" \
    -x MSCCL_XML_FILES="/home/ec2-user/deps/msccl-tools-lyd/examples/xml/xml_lyd/aws-test/8nic/16gpus/allreduce_binary_tree_node2_gpu16_mcl8_mck64_gan0.xml" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/msccl/all-reduce_sum_float_binary-tree_node2_gpu16_mcl8_mck64_i0.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/home/ec2-user/deps/msccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/home/ec2-user/deps/msccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="MSCCL,TREE,RING" \
    -x MSCCL_XML_FILES="/home/ec2-user/deps/msccl-tools-lyd/examples/xml/xml_lyd/aws-test/8nic/16gpus/allreduce_binary_tree_node2_gpu16_mcl8_mck32_gan0.xml" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/msccl/all-reduce_sum_float_binary-tree_node2_gpu16_mcl8_mck32_i0.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="/home/ec2-user/deps/msccl/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:/home/ec2-user/deps/msccl/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="MSCCL,TREE,RING" \
    -x MSCCL_XML_FILES="/home/ec2-user/deps/msccl-tools-lyd/examples/xml/xml_lyd/aws-test/8nic/16gpus/allreduce_binary_tree_node2_gpu16_mcl8_mck16_gan0.xml" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > /home/ec2-user/deps/aws-setup-lyd/aws-setup-lyd/logs/msccl/all-reduce_sum_float_binary-tree_node2_gpu16_mcl8_mck16_i0.log 2>&1

mpirun --hostfile ~/hostfile --map-by ppr:8:node \
    -x CUDA_HOME="/usr/local/cuda" \
    -x CUDA_PATH="/usr/local/cuda" \
    -x NCCL_HOME="$MSCCL_HOME/build" \
    -x MPI_HOME="/opt/amazon/openmpi" \
    -x LD_LIBRARY_PATH="/opt/aws-ofi-nccl/lib:/opt/amazon/openmpi/lib64:$MSCCL_HOME/build/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}" \
    -x NCCL_DEBUG="TRACE" \
    -x NCCL_ALGO="MSCCL,TREE,RING" \
    -x MSCCL_XML_FILES="/home/ec2-user/deps/msccl-tools-lyd/examples/xml/xml_lyd/aws-test/8nic/16gpus/allreduce_binary_tree_node2_gpu16_mcl8_mck1_gan0.xml" \
    -x FI_EFA_FORK_SAFE=1 \
    -x GENMSCCLXML=1 \
    --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /home/ec2-user/deps/nccl-tests-lyd/build/all_reduce_perf \
    --nthreads 1 \
    --ngpus 1 \
    --minbytes 512K \
    --maxbytes 256M \
    --stepfactor 2 \
    --op sum \
    --datatype float \
    --iters 20 \
    --warmup_iters 5 > $SCRIPT_LYD_HOME/logs/msccl/all-reduce_sum_float_binary-tree_node2_gpu16_mcl8_mck1_i0.log 2>&1