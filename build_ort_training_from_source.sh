#!/usr/bin/env bash

set -eoux pipefail

pip uninstall onnxruntime-training -y

export CUDA_VERSION=11.8

# set the package path
export CUDA_HOME=/usr/local/cuda-$CUDA_VERSION
export CUDNN_HOME=/usr/local/cuda-$CUDA_VERSION
export CUDACXX=/usr/local/cuda-$CUDA_VERSION/bin/nvcc

# save the package to onnxruntime

mkdir -p acpt
cd /acpt

# clone the onnxruntime repo
git clone https://github.com/microsoft/onnxruntime

cd onnxruntime

/bin/sh build.sh --parallel \
        --build_shared_lib \
        --enable_training \
        --cuda_version ${CUDA_VERSION} \
        --cuda_home ${CUDA_HOME} \
        --cudnn_home ${CUDNN_HOME} \
        --config Debug \
        --build_wheel \
        --enable_nvtx_profile \
        --skip_tests \
        --use_cuda \
        --allow_running_as_root

# Install the onnxruntime whe
python -m pip install --no-index --no-deps ./build/Linux/RelWithDebInfo/dist/*.whl
cd ..
# remove acpt
rm -rf ./acpt

# enable ORTModule
python -m onnxruntime.training.ortmodule.torch_cpp_extensions.install
# For onnxruntime local pytest, we might need to run `sudo apt-get install --only-upgrade libstdc++6` 
