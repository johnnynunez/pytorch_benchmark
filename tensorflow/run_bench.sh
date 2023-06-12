#!/bin/bash
# This script is used to install the torchbenchmark environment and run the first run
# ./script.sh <name_ngc> <name_dataset> <name_config> <name_model> <timeout>
git clone https://github.com/johnnynunez/benchmarks.git
cd benchmarks
python3 perfzero/lib/setup.py --dockerfile_path=docker/Dockerfile_ubuntu_2204_tf_cuda_12
docker run --gpus all -it -v $(pwd):/workspace -v /data:/data perfzero/tensorflow bash

python3 /workspace/perfzero/lib/benchmark.py \
--git_repos="https://github.com/johnnynunez/models.git;benchmark" \
--python_path=models \
--gcloud_key_file_url="" \
--python_path=models \
--benchmark_methods=official.benchmark.keras_cifar_benchmark.Resnet56KerasBenchmarkReal.benchmark_1_gpu_no_dist_strat \
--root_data_dir=/data