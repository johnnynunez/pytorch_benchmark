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

export NAME_NGC="$NAME_NGC"
export NAME_DATASET="$NAME_DATASET"

# PREPARE DATA
chmod +x setup.sh && \
./setup.sh $NAME_NGC

cd deeplearning-benchmark/pytorch && \
docker run --gpus all --rm --shm-size=64g \
-v ~/DeepLearningExamples/PyTorch:/workspace/benchmark \
-v ~/data:/data \
-v $(pwd)"/scripts":/scripts \
nvcr.io/nvidia/${NAME_NGC} \
/bin/bash -c "cp -r /scripts/* /workspace;  ./run_prepare.sh $NAME_DATASET"

# RUN BENCHMARK

export NAME_NGC="$NAME_NGC"
export NAME_CONFIG="$NAME_CONFIG"
export NAME_MODEL="$NAME_MODEL"
export TIME_OUT="$TIME_OUT"

docker run \
	--rm --shm-size=1024g \
	--gpus all \
	-v ~/DeepLearningExamples/PyTorch:/workspace/benchmark \
	-v ~/data:/data \
	-v $(pwd)"/scripts":/scripts \
	-v $(pwd)"/results":/results \
	nvcr.io/nvidia/${NAME_NGC} \
	/bin/bash -c "cp -r /scripts/* /workspace; ./run_benchmark.sh $NAME_CONFIG $NAME_MODEL $TIME_OUT"

cd benchmarks
git clone https://github.com/tensorflow/benchmarks
python3 perfzero/lib/setup.py --dockerfile_path=docker/Dockerfile_ubuntu_1804_tf_v2
docker run -it --rm -v $(pwd):/workspace -v /data:/data perfzero/tensorflow bash
python3 /workspace/perfzero/lib/benchmark.py \
--git_repos="https://github.com/tensorflow/models.git;benchmark" \
--python_path=models \
--gcloud_key_file_url="" \
--benchmark_methods=official.benchmark.keras_cifar_benchmark.Resnet56KerasBenchmarkSynth.benchmark_1_gpu_no_dist_strat
