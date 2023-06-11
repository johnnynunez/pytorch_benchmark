# default base image: xzhao9/gcp-a100-runner-dind:latest
# ghcr.io/pytorch:pytorch-nightly
# nvcr.io/nvidia/pytorch:23.05-py3
ARG BASE_IMAGE=ghcr.io/pytorch/pytorch-nightly:latest
FROM ${BASE_IMAGE}

ARG CUDA_VERSION=11.8
ENV CUDA_VERSION ${CUDA_VERSION}
ENV CONDA_ENV=torchbench
ENV CONDA_ENV_PATH=/opt/conda/envs/${CONDA_ENV}
ENV SETUP_SCRIPT=/workspace/setup_instance.sh
ENV DEBIAN_FRONTEND=noninteractive

RUN echo CUDA VERSION: $CUDA_VERSION

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get -y update && apt -y update \
    && apt-get install -y git jq vim wget curl ninja-build cmake libgl1-mesa-glx libsndfile1-dev kmod \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=

# setup conda by default
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ${HOME}/.bashrc

RUN echo "\
. \${HOME}/miniconda3/etc/profile.d/conda.sh\n\
conda activate base\n\
export CONDA_HOME=\${HOME}/miniconda3\n\
export CUDA_HOME=/usr/local/cuda\n\
export PATH=\${CUDA_HOME}/bin\${PATH:+:\${PATH}}\n\
export LD_LIBRARY_PATH=\${CUDA_HOME}/lib64:/usr/local/nvidia/lib64:/opt/conda/lib/python3.10/site-packages/torch/lib\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}\n\
export LIBRARY_PATH=\${CUDA_HOME}/lib64\${LIBRARY_PATHPATH:+:\${LIBRARY_PATHPATH}}\n"


# Setup Conda env and CUDA
RUN git clone https://github.com/pytorch/benchmark /workspace/benchmark

# delete folder filled in benchmark/torchbenchmark/models/torchrec_dlrm
RUN rm -rf /workspace/benchmark/torchbenchmark/models/torchrec_dlrm

# REMOVE model torchrec

RUN python /workspace/benchmark/utils/python_utils.py --create-conda-env ${CONDA_ENV} && \
    conda init bash && \
    eval "$(conda shell.bash hook)" && \
    conda activate torchbench && \
    echo "conda activate torchbench" >> ${HOME}/.bashrc && \
    conda update --all --yes



# Install PyTorch nightly and verify the date is correct
RUN cd /workspace/benchmark && \
    conda init bash && \
    eval "$(conda shell.bash hook)" && \
    conda activate torchbench && \
    python utils/cuda_utils.py --install-torch-deps --cudaver=${CUDA_VERSION} && \
    python utils/cuda_utils.py --install-torch-nightly --cudaver=${CUDA_VERSION}
    # python utils/cuda_utils.py --check-torch-nightly-version --cudaver=${CUDA_VERSION}

# Install TorchBench conda and python dependencies
RUN cd /workspace/benchmark && \
    conda init bash && \
    eval "$(conda shell.bash hook)" && \
    conda activate torchbench && \
    python utils/cuda_utils.py --install-torchbench-deps --cudaver=${CUDA_VERSION} && \
    cc_path=$(conda run -n "${CONDA_ENV}" printenv CC) && \
    cxx_path=$(conda run -n "${CONDA_ENV}" printenv CXX) && \
    ln -s "${cc_path}" "$(dirname "$cc_path")/cc" && \
    ln -s "${cc_path}" "$(dirname "$cc_path")/gcc" && \
    ln -s "${cxx_path}" "$(dirname "$cxx_path")/c++" && \
    ln -s "${cxx_path}" "$(dirname "$cxx_path")/g++"

RUN cd /workspace/benchmark && \
    conda init bash && \
    eval "$(conda shell.bash hook)" && \
    conda activate torchbench && \
    python install.py && \
    pip3 install -U fbgemm-gpu-nightly



# change file where is in workspace/benchmark/torchbenchmark/models/hf_T5_base/__init__.py DEFAULT_TRAIN_BSIZE = 8 to 4
RUN sed -i 's/DEFAULT_TRAIN_BSIZE = 8/DEFAULT_TRAIN_BSIZE = 4/g' /workspace/benchmark/torchbenchmark/models/hf_T5_base/__init__.py
RUN sed -i 's/DEFAULT_TRAIN_BSIZE = 32/DEFAULT_TRAIN_BSIZE = 16/g' /workspace/benchmark/torchbenchmark/models/timm_vision_transformer_large/__init__.py


EXPOSE 22


CMD [eval "$(conda shell.bash hook)" && conda activate torchbench]
