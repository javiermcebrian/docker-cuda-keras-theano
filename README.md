# docker-cuda-keras-theano

This repository defines an environment for Keras/Theano for GPU using [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker):

* environment-manager.sh: bash file to manage the docker environment (build, run, stop, clean). First set 'image' and 'volume' user defined constants
* Dockerfile: python3.6, libgpuarray for Theano @ GPU, .theanorc, user permissions from host, other dependencies and env vars
* requirements.txt: python requirements as usual
* .theanorc: theano configuration file
* check_theano_gpu.py: script to check if using GPU or not
