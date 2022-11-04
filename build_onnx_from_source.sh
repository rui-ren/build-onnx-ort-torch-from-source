#!/usr/bin/env bash
set -eoux pipefail

# update
apt update
apt upgrade -y

# update the packages
apt-get install python3-pip python3-dev libprotobuf-dev protobuf-compiler -y

# uninstall protobuf
pip uninstall protobuf -y
pip uninstall onnx -y

# build protobuf from source
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git checkout v3.20.1
git submodule update --init --recursive
mkdir build_source && cd build_source
cmake ../cmake -Dprotobuf_BUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_POSITION_INDEPENDENT_CODE=ON -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
make install

# update the protobuf PATH
export PATH=$PATH:/protobuf/build_source/lib

cd /acpt

# build onnx from source
git clone https://github.com/onnx/onnx.git
cd onnx
git checkout v${onnx_version}
git clean -xdf
python setup.py clean
git submodule sync
git submodule deinit -f .
git submodule update --init --recursive
# Optional: prefer lite proto
export CMAKE_ARGS=-DONNX_USE_LITE_PROTO=ON
python setup.py install
