
FROM [**Your Image**]

ENV APP_HOME=/acpt

RUN mkdir ${APP_HOME}

WORKDIR ${APP_HOME}

LABEL maintainer="acpt container"
LABEL description="debug image"

RUN apt-get update \
    && apt-get install -y build-essential

RUN pip install --upgrade pip

COPY ./build_onnx_from_source.sh ${APP_HOME}/build_onnx_from_source.sh
COPY ./build_ort_training_from_source.sh ${APP_HOME}/build_ort_training_from_source.sh
COPY ./build_pytorch_from_source.sh ${APP_HOME}/build_pytorch_from_source.sh
COPY ./install_python_packages.sh ${APP_HOME}/install_python_packages.sh

RUN bash install_python_packages.sh

RUN echo "Debug Image Build Finished"
