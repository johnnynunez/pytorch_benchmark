conda create -n torchbenchmark python=3.8
conda activate torchbenchmark
conda install -y git-lfs
conda install -y -c pytorch magma-cuda118
conda install pytorch torchtext torchvision torchaudio pytorch-cuda=11.8 -c pytorch-nightly -c nvidia
conda install -y pyyaml
git clone https://github.com/pytorch/benchmark.git
cd benchmark
python install.py
pytest test_bench.py --benchmark-autosave --ignore_machine_config
