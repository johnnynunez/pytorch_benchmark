#!/bin/bash
# This script is used to install the torchbenchmark environment and run the first run
# ./script.sh <name_ngc> <name_dataset> <name_config> <name_model> <timeout>

# Set default values for arguments
CUDA_VERSION="${1:-12.1}"
NAME_NGC="${2:-pytorch:23.05-py3}"
NAME_DATASET="${3:-all}"
NAME_CONFIG="${4:-AdaA6000_v1}"
NAME_MODEL="${5:-all}"
TIME_OUT="${6:-3000}"

docker build --build-arg CUDA_VERSION=$CUDA_VERSION -t pytorch_benchmark -f docker/Dockerfile .

# Run the benchmark inside the container
# docker run --gpus all -it -v "${PWD}:/prueba" pytorch_benchmark /bin/bash -c "cd benchmark && eval \"\$(conda shell.bash hook)\" && conda activate torchbench && pytest test_bench.py --benchmark-autosave --benchmark-json ~/prueba --ignore_machine_config --cuda_only"

# docker run --gpus all -it -v "${PWD}/workspace:/workspace" pytorch_benchmark /bin/bash -c "cd /workspace/benchmark && eval \"\$(conda shell.bash hook)\" && conda activate torchbench && python run_benchmark.py torch-nightly -d cuda -t train,eval"
docker run --gpus all -it -v "${PWD}/workspace:/workspace" pytorch_benchmark /bin/bash -c "cd benchmark && eval \"\$(conda shell.bash hook)\" && conda activate torchbench && python run_benchmark.py torch-nightly -d cuda -t train,eval"