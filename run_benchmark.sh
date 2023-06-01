#!/bin/bash
# This script is used to install the torchbenchmark environment and run the first run
docker build --build-arg CUDA_VERSION=12.1 -t pytorch_benchmark .
docker run --rm -it --gpus all --name pytorch_benchmark -v /workspace:/workspace pytorch_benchmark

# Run the benchmark
cd /workspace/benchmark
pytest test_bench.py --benchmark-autosave --ignore_machine_config