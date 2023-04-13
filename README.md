# pytorch_benchmark

# Run easier with DOCKER
```url
https://hackmd.io/@johnnync13/By7fEjBG2
```


# Compatible with CUDA 11.8 and CUDA 12.0

### First of all install Anaconda, git and pv
```bash
sudo apt-get install git
sudo apt-get install pv
```

```bash
git clone https://github.com/johnnynunez/pytorch_benchmark.git
```
### First run this to preparare models and data
```bash
chmod +x first_run.sh
bash first_run.sh
```
### Run Benchmark
```bash
chmod +x run_benchmark.sh
bash run_benchmark.sh
```
If there any problem
```
conda activate torchbenchmark
```
### Monitoring your GPU and CPU
```bash
sudo apt-get install git htop nvtop
```
