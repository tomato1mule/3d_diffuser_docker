FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
SHELL ["/bin/bash", "-c"]


RUN apt update &&  \
    DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends  \
    wget curl unzip git make cmake gcc clang gdb libeigen3-dev build-essential vim  \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
    
RUN echo 'if [ "$color_prompt" = yes ]; then' >> ~/.bashrc && \
    echo '    PS1='\''${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '\''' >> ~/.bashrc && \
    echo 'else' >> ~/.bashrc && \
    echo '    PS1='\''${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '\''' >> ~/.bashrc && \
    echo 'fi' >> ~/.bashrc

# --------------------------------------------------------------- #
# Install MiniConda and Mamba
# https://fabiorosado.dev/blog/install-conda-in-docker/
# https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html
# --------------------------------------------------------------- #
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
RUN rm miniconda.sh
RUN . ~/.bashrc && \
    conda init && \
    conda install mamba -c conda-forge -y


# --------------------------------------------------------------- #
# Install 3D Diffuser Actor
# --------------------------------------------------------------- #
RUN git clone -b diffusion-edf https://github.com/bhkim94/3d_diffuser_actor.git
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh;  \
    cd 3d_diffuser_actor; conda update conda && mamba env create -f environment.yaml && \
    conda activate 3d_diffuser_actor && \
    pip install -e . && \
    pip install dgl -f https://data.dgl.ai/wheels/cu117/dgl-1.1.3%2Bcu117-cp38-cp38-manylinux1_x86_64.whl && \
    pip install packaging && pip install ninja && pip install flash-attn --no-build-isolation

# --------------------------------------------------------------- #
# Misc
# --------------------------------------------------------------- #
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate 3d_diffuser_actor && \
    pip install jupyter


# --------------------------------------------------------------- #
# Install CoppeliaSim
# --------------------------------------------------------------- #
RUN wget https://www.coppeliarobotics.com/files/V4_1_0/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz  && \
    tar -xf CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz -C $HOME && \
    rm CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz

RUN echo "export COPPELIASIM_ROOT=$HOME/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04" >> $HOME/.bashrc  && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$COPPELIASIM_ROOT" >> $HOME/.bashrc  && \
    echo "export QT_QPA_PLATFORM_PLUGIN_PATH=\$COPPELIASIM_ROOT" >> $HOME/.bashrc && \
    export COPPELIASIM_ROOT=$HOME/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04 && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT && \
    export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT && \
    . $HOME/.bashrc

# --------------------------------------------------------------- #
# Install Dependencies for 3D-Diffuser
# --------------------------------------------------------------- #

# install diffuser
#  #. ~/.bashrc && \
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    pip install diffusers["torch"]==0.25

# install dgl (https://www.dgl.ai/pages/start.html)
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    pip install dgl==1.1.3 -f https://data.dgl.ai/wheels/cu117/repo.html

# install flash attention (https://github.com/Dao-AILab/flash-attention#installation-and-features)
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    pip install packaging && \
    pip install ninja && \
    pip install flash-attn --no-build-isolation

# --------------------------------------------------------------- #
# Install Calvin locally
# --------------------------------------------------------------- #

# RUN git clone --recurse-submodules https://github.com/mees/calvin.git
RUN git clone --recurse-submodules --no-checkout https://github.com/mees/calvin.git && \
    cd calvin && \
    git checkout 8315a697cf0a175b8e5dcb9a3dc96f9ea5d48580 && \
    git submodule update --init --recursive
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    export CALVIN_ROOT=$(pwd)/calvin && \
    cd calvin && \
    cd calvin_env; git checkout main && \
    cd .. && \
    ./install.sh; cd ..

# --------------------------------------------------------------- #
# Install RLBench locally
# --------------------------------------------------------------- #

# Install open3D
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    pip install open3d

# Install PyRep (https://github.com/stepjam/PyRep?tab=readme-ov-file#install)
# RUN git clone https://github.com/stepjam/PyRep.git
RUN git clone --no-checkout https://github.com/stepjam/PyRep.git && \
    cd PyRep && \
    git checkout 076ca15c57f2495a4194da03565891ab1aaa317e
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && \
    conda activate 3d_diffuser_actor && \
    export COPPELIASIM_ROOT=$HOME/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04 && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT && \
    export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT && \
    cd PyRep/ && \
    pip install -r requirements.txt && \
    pip install -e . && \
    cd ..

# Install RLBench (Note: there are different forks of RLBench)
# PerAct setup
#RUN git clone https://github.com/MohitShridhar/RLBench.git
#RUN . ~/.bashrc && conda activate 3d_diffuser_actor && \
#     cd RLBench; git checkout -b peract --track origin/peract; pip install -r requirements.txt; pip install -e .; cd ..;
RUN git clone -b peract https://github.com/MohitShridhar/RLBench.git
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && conda activate 3d_diffuser_actor && \
    cd RLBench; pip install -r requirements.txt; pip install -e .; cd ..;

# --------------------------------------------------------------- #
# Always activate Conda Env.
# --------------------------------------------------------------- #
RUN echo 'conda activate 3d_diffuser_actor' >> ~/.bashrc

# ImportError: libGL.so.1: cannot open shared object file: No such file or directory
RUN apt update && apt install ffmpeg libsm6 libxext6 -y

#qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "/root/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04" even though it was found.
#This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
#Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vnc, webgl, xcb.
RUN apt-get update && apt-get install -y qt5-default libxcb-xinerama0-dev

# CUDA 11.7
RUN . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && conda activate 3d_diffuser_actor && \
    pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117 torchdata==0.5.1 beartype e3nn xitorch numpy==1.23.5

# torch-scatter, torch-cluster w/ CUDA 11.7
RUN export PATH="/usr/local/cuda-11.7/bin:\$PATH"; \
    export LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:\$LD_LIBRARY_PATH"; \
    echo "export PATH=/usr/local/cuda-11.7/bin:\$PATH" >> $HOME/.bashrc  && \
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64:\$LD_LIBRARY_PATH" >> $HOME/.bashrc && \
    . ~/.bashrc && . /opt/conda/etc/profile.d/conda.sh && conda activate 3d_diffuser_actor && \
    pip install torch-scatter -f https://data.pyg.org/whl/torch-1.13.1+cu117.html; \
    pip install torch-cluster -f https://data.pyg.org/whl/torch-1.13.1+cu117.html


