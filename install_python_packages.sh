#!/usr/bin/env bash
set -eoux pipefail

. build_pytorch_from_source.sh | sed "s/^/[install_pytorch.sh] /"
. build_onnx_from_source.sh | sed "s/^/[install_onnx.sh] /"
. build_ort_training_from_source.sh | sed "s/^/[install_onnxruntime.sh] /"

pip uninstall torch-ort -y
pip install torch-ort
python -m torch_ort.configure

echo "finished all the essential packages!"
