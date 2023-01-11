# default base image: PyTorch nightly docker
# ghcr.io/pytorch:pytorch-nightly
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:22.12-py3
FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essentials  && \
    apt-get install -y wget && apt-get clean 

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# setup conda by default
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ${HOME}/.bashrc

RUN apt-get update
RUN apt-get install -y git git-lfs jq

RUN git clone https://github.com/pytorch/benchmark /workspace/benchmark

# Clone conda env
RUN conda create --name torchbench --clone base && \
    echo "conda activate torchbench" >> ${HOME}/.bashrc

# Run the setup
RUN cd /workspace/benchmark; python install.py
