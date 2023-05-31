# default base image: PyTorch nightly docker
# ghcr.io/pytorch:pytorch-nightly
ARG BASE_IMAGE=ghcr.io/pytorch/torchbench:latest

FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8


ENV CONDA_ENV=torchbench
ENV SETUP_SCRIPT=/workspace/setup_instance.sh