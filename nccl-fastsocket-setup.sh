export SHARED_HOME_DIRECTORY=/sharedfs

pushd $SHARED_HOME_DIRECTORY

wget https://github.com/bazelbuild/bazel/releases/download/6.1.1/bazel-6.1.1-linux-x86_64

chmod +x bazel-6.1.1-linux-x86_64

sudo mv bazel-6.1.1-linux-x86_64 /usr/local/bin/bazel

export PATH=/usr/local/bin/bazel:$PATH

echo 'export PATH=/usr/local/bin/bazel:$PATH' >> ~/.bashrc
source ~/.bashrc

bazel --version

git@github.com:google/nccl-fastsocket.git

pushd nccl-fastsocket

bazel build :all

export LD_LIBRARY_PATH=${SHARED_HOME_DIRECTORY}/nccl-fastsocket/bazel-bin/libnccl-net.so:$LD_LIBRARY_PATH

popd

popd

