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

docker run --gpus all -it -v "${PWD}:/prueba" pytorch_benchmark /bin/bash -c "cd benchmark && eval \"\$(conda shell.bash hook)\" && conda activate torchbench && python run_benchmark.py torch-nightly -d cuda -t train,eval"

export NAME_NGC="$NAME_NGC"
export NAME_DATASET="$NAME_DATASET"

wget https://raw.githubusercontent.com/lambdal/deeplearning-benchmark/master/pytorch/setup.sh && \
chmod +x setup.sh && \
./setup.sh $NAME_NGC

cd deeplearning-benchmark/pytorch && \
docker run --gpus all --rm --shm-size=64g \
-v ~/DeepLearningExamples/PyTorch:/workspace/benchmark \
-v ~/data:/data \
-v $(pwd)"/scripts":/scripts \
nvcr.io/nvidia/${NAME_NGC} \
/bin/bash -c "cp -r /scripts/* /workspace;  ./run_prepare.sh $NAME_DATASET"

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
python3 perfzero/lib/setup.py --dockerfile_path=docker/Dockerfile_ubuntu_1804_tf_v2
nvidia-docker run -it --rm -v $(pwd):/workspace -v /data:/data perfzero/tensorflow bash
python3 /workspace/perfzero/lib/benchmark.py \
--git_repos="https://github.com/tensorflow/models.git;benchmark" \
--python_path=models \
--gcloud_key_file_url="" \
--benchmark_methods=official.benchmark.keras_cifar_benchmark.Resnet56KerasBenchmarkSynth.benchmark_1_gpu_no_dist_strat
