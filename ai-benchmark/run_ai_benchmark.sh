#!/bin/bash
# This script is used to install the torchbenchmark environment and run the first run
# ./script.sh <name_ngc> <name_dataset> <name_config> <name_model> <timeout>

docker build -t ai_benchmark .
docker run --gpus all -it -v $(pwd):/workspace -v /data:/data ai_benchmark /bin/bash -c "python3 /workspace/ai.py"

