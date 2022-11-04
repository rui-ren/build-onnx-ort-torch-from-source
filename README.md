##  Build-onnx-ort-torch-from-source


build onnx onnxruntime and pytorch from source

1. Setup the onnx, ort and torch version

```
export onnx_version==1.12.0
export ort_version=1.13.1
export torch_version=1.12.1
```
> You can also update the `protobuf` version inside the `build_onnx_from_source.sh` file

2. Update the base image

`FROM ***` in the `Dockerfile`

Use the base image for your local build, e.g. ACPT (Azure Container for Pytorch) image

<img width="418" alt="image" src="https://user-images.githubusercontent.com/15321482/199653662-baf31502-b6b7-4097-9594-ac9b4cbef2a3.png">


3. Build the image
`docker build . -t debug_image --no-cache`
