#!/bin/bash

# Use $OMPI_COMM_WORLD_LOCAL_RANK to get a unique ID for each process on the node
export CUDA_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK

# Then execute the command passed to the script
exec "$@"
