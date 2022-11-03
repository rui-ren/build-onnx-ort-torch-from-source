#!/usr/bin/env bash

set -eoux pipefail

pip uninstall torch -y

conda install astunparse numpy ninja pyyaml setuptools cmake cffi typing_extensions future six requests dataclasses

conda install mkl mkl-include
# CUDA only: Add LAPACK support for the GPU if needed
conda install -c pytorch magma-cuda110  # or the magma-cuda* that matches your CUDA version from https://anaconda.org/pytorch/repo

# Get PyTorch Packages
git clone --recursive https://github.com/pytorch/pytorch
cd pytorch
git checkout ${torch_version}
export PYTORCH_BUILD_NUMBER=1
export REL_WITH_DEB_INFO=1

# Compile the model
git clean -xdf
python setup.py clean
git submodule sync
git submodule deinit -f .
git submodule update --init --recursive --jobs 0
export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}
python setup.py install
