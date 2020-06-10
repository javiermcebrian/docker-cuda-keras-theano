# Devel version as we need lib64 and include cuda paths
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

# Install dependencies as root for python3.6 and others
RUN apt update && apt install sudo && sudo apt update && \
    sudo apt install -y software-properties-common curl && \
    sudo add-apt-repository ppa:deadsnakes/ppa && \
    sudo apt update && sudo apt -y upgrade && \
    sudo apt install -y python3.6 && \
    curl https://bootstrap.pypa.io/get-pip.py | sudo -H python3.6

# Install BLAS + LAPACK and other dependencies
RUN apt update && apt install -y gfortran liblapack-dev libopenblas-dev \
    python3.6-dev python-numpy python-scipy python-nose \
    git g++ cmake

# Install requirements as root
COPY requirements.txt /tmp/requirements.txt
RUN sudo pip3.6 install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Install libgpuarray from github
RUN git clone --branch v0.7.6 https://github.com/Theano/libgpuarray.git && \
    cd libgpuarray && mkdir Build && cd Build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make && make install && \
    cd .. && python3.6 setup.py build && \
    python3.6 setup.py install

# Add user based on host definitions
ARG USER_NAME
ARG USER_ID
ARG GROUP_NAME
ARG GROUP_ID
RUN sudo groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    sudo useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}

# Set workspace and user
WORKDIR /home/${USER_NAME}
RUN chown -R ${USER_NAME}:${GROUP_NAME} /home/${USER_NAME}
USER ${USER_NAME}

# Copy .theanorc
COPY .theanorc /home/${USER_NAME}/.theanorc

# Set Keras backend as Theano
ENV KERAS_BACKEND="theano"

# Entry command
CMD ["bash"]