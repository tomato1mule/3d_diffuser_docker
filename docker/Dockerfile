FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

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
    conda install mamba -c conda-forge 

# --------------------------------------------------------------- #
# Create Conda Env
# --------------------------------------------------------------- #
COPY environment.yaml environment.yaml
RUN . ~/.bashrc && \
    mamba env create -f environment.yaml

# --------------------------------------------------------------- #
# Install CoppeliaSim
# --------------------------------------------------------------- #
RUN wget https://www.coppeliarobotics.com/files/V4_1_0/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz  && \
    tar -xf CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz -C $HOME && \
    rm CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz

RUN echo "export COPPELIASIM_ROOT=$HOME/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz" >> $HOME/.bashrc  && \ 
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$COPPELIASIM_ROOT" >> $HOME/.bashrc  && \
    echo "export QT_QPA_PLATFORM_PLUGIN_PATH=\$COPPELIASIM_ROOT" >> $HOME/.bashrc && \
    . $HOME/.bashrc

# --------------------------------------------------------------- #
# Install Dependencies for 3D-Diffuser
# --------------------------------------------------------------- #

# install diffuser
RUN . ~/.bashrc && \
    conda activate 3d_diffuser_actor && \
    pip install diffusers["torch"]==0.25

# install dgl (https://www.dgl.ai/pages/start.html)
RUN . ~/.bashrc && \
    conda activate 3d_diffuser_actor && \
    pip install dgl==1.1.3 -f https://data.dgl.ai/wheels/cu117/repo.html

# install flash attention (https://github.com/Dao-AILab/flash-attention#installation-and-features)
RUN . ~/.bashrc && \
    conda activate 3d_diffuser_actor && \
    pip install packaging && \
    pip install ninja && \
    pip install flash-attn --no-build-isolation

# --------------------------------------------------------------- #
# Install Calvin locally
# --------------------------------------------------------------- #

RUN git clone --recurse-submodules https://github.com/mees/calvin.git
RUN . ~/.bashrc && \
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
RUN . ~/.bashrc && \
    conda activate 3d_diffuser_actor && \
    pip install open3d

# Install PyRep (https://github.com/stepjam/PyRep?tab=readme-ov-file#install)
RUN git clone https://github.com/stepjam/PyRep.git
RUN . ~/.bashrc && \
    conda activate 3d_diffuser_actor && \
    cd PyRep/ && \
    pip install -r requirements.txt; pip install -e .; cd ..

# Install RLBench (Note: there are different forks of RLBench)
# PerAct setup
RUN . ~/.bashrc && conda activate 3d_diffuser_actor && \
    git clone https://github.com/MohitShridhar/RLBench.git && \
    cd RLBench; git checkout -b peract --track origin/peract; pip install -r requirements.txt; pip install -e .; cd ..;


# --------------------------------------------------------------- #
# Always activate Conda Env.
# --------------------------------------------------------------- #
RUN echo 'conda activate 3d_diffuser_actor' >> ~/.bashrc