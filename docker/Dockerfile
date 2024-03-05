FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel

ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute


RUN apt update &&  \
    DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends  \
    wget curl unzip git make cmake gcc clang gdb libeigen3-dev build-essential vim  \
    libncurses5-dev libncursesw5-dev libfreeimage-dev  \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libgtk-3-dev pkg-config libcanberra-gtk-module libcanberra-gtk3-module lsb  \
    apt-transport-https \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
    
RUN echo 'if [ "$color_prompt" = yes ]; then' >> ~/.bashrc && \
    echo '    PS1='\''${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '\''' >> ~/.bashrc && \
    echo 'else' >> ~/.bashrc && \
    echo '    PS1='\''${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '\''' >> ~/.bashrc && \
    echo 'fi' >> ~/.bashrc

# --------------------------------------------------------------- #
# Install Torch GNN Packages
# --------------------------------------------------------------- #
RUN pip install torch_geometric
RUN pip install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.2.1+cu121.html



# --------------------------------------------------------------- #
# Install CoppeliaSim
# --------------------------------------------------------------- #

RUN wget https://www.coppeliarobotics.com/files/V4_6_0_rev16/CoppeliaSim_Edu_V4_6_0_rev16_Ubuntu22_04.tar.xz  && \
    tar -xf CoppeliaSim_Edu_V4_6_0_rev16_Ubuntu22_04.tar.xz && \
    rm CoppeliaSim_Edu_V4_6_0_rev16_Ubuntu22_04.tar.xz

RUN echo "export COPPELIASIM_ROOT=$PWD/CoppeliaSim_Edu_V4_6_0_rev16_Ubuntu22_04" >> ~/.bashrc  && \ 
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$COPPELIASIM_ROOT" >> ~/.bashrc  && \
    echo "export QT_QPA_PLATFORM_PLUGIN_PATH=\$COPPELIASIM_ROOT" >> ~/.bashrc && \
    . ~/.bashrc




# --------------------------------------------------------------- #
# Install graphics related packages.
# --------------------------------------------------------------- #

# RUN apt-get update && \
#     DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
#     xorg libxcb-randr0-dev libxrender-dev libxkbcommon-dev libxkbcommon-x11-0 libavcodec-dev libavformat-dev libswscale-dev \
#     && \
#     rm -rf /var/lib/apt/lists/*


# RUN nvidia-xconfig -a --virtual=1280x1024 && \
#     wget https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl_2.5.2_amd64.deb/download -O virtualgl_2.5.2_amd64.deb --no-check-certificate && \
#     dpkg -i virtualgl*.deb && \
#     rm virtualgl*.deb








