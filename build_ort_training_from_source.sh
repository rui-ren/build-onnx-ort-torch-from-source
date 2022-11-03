#!/usr/bin/env bash

set -eoux pipefail

pip uninstall onnxruntime-training -y

export CUDA_VERSION=11.6

# set the package path
export TRT_HOME=/usr/lib/x86_64-linux-gnu
export CUDA_HOME=/usr/local/cuda-$CUDA_VERSION
export CUDNN_HOME=/usr/local/cuda-$CUDA_VERSION
export CUDACXX=/usr/local/cuda-$CUDA_VERSION/bin/nvcc
export PATH=/usr/lib/x86_64-linux-gnu/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/openmpi/lib:$LD_LIBRARY_PATH
export MPI_CXX_INCLUDE_PATH=/usr/lib/x86_64-linux-gnu/openmpi/include/
export CMAKE_CUDA_ARCHITECTURES="37;50;52;60;61;70;75;80"

# Install TensorRT
v="8.4.1-1+cuda11.6"
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
apt-get update
sudo apt-get install -y libnvinfer8=${v} \
    libnvonnxparsers8=${v} \
    libnvparsers8=${v} \
    libnvinfer-plugin8=${v} \
    libnvinfer-dev=${v} \
    libnvonnxparsers-dev=${v} \
    libnvparsers-dev=${v} \
    libnvinfer-plugin-dev=${v} \
    python3-libnvinfer=${v} \
    libnvinfer-samples=${v}

# Compile trtexec
cd /usr/src/tensorrt/samples/trtexec && make

# save the package to onnxruntime
cd /acpt

# clone the onnxruntime repo
git clone https://github.com/microsoft/onnxruntime

cd onnxruntime

# install the stable version of onnxruntime
git checkout ${ort_version}

/bin/sh build.sh --enable_training \
    --use_cuda \
    --parallel \
    --build_shared_lib \
    --cuda_home ${CUDA_HOME} \
    --cudnn_home ${CUDNN_HOME} \
    --use_tensorrt \
    --tensorrt_home ${TRT_HOME} \
    --config=RelWithDebInfo \
    --build_wheel \
    --skip_tests \
    --cmake_extra_defines '"CMAKE_CUDA_ARCHITECTURES='${CMAKE_CUDA_ARCHITECTURES}'"'
# Install the onnxruntime whe
python -m pip install --no-index --no-deps ./build/Linux/RelWithDebInfo/dist/*.whl
cd ..
