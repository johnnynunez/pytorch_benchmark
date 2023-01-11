#!/bin/bash

conda create -n torchbenchmark python=3.8 -y
eval "$(conda shell.bash hook)"
source activate torchbenchmark
conda activate torchbenchmark
envs=$(conda info --envs)
# Extract the name of the active environment
active_env=$(echo "$envs" | grep '*' | awk '{print $1}')

# Print the active environment
echo "Active environment: $active_env"

conda update --all --yes
conda install -y git-lfs ninja
conda install -y -c pytorch magma-cuda118
yes | pip3 install -U --pre torch torchtext torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cu118
yes | pip3 install pyyaml

if [ -d benchmark ]; then
    echo "benchmark exists"
else
    echo "Cloning repository"
    git clone https://github.com/pytorch/benchmark.git
fi 

# copy requirements.txt to benchmark folder
cp -r requirements.txt benchmark/requirements.txt
cd benchmark
sed -i 's/git+https:\/\/github.com\/facebookresearch\/detectron2.git@c470ca3/git+https:\/\/github.com\/johnnynunez\/detectron2.git/g' torchbenchmark/util/framework/detectron2/requirements.txt
yes | pip3 install -U -r requirements.txt
python install.py -v --continue_on_fail
