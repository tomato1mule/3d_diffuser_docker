# 3D_Diffuser_Docker

## Installation
```bash
sudo docker pull nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
sudo docker build -t 3diff:latest docker/.
bash docker/run_docker.sh

# Optional
docker cp data/peract/raw <container_id>:/root/3d_diffuser_actor/data/peract
docker cp instructions <container_id>:/root/3d_diffuser_actor
```

## Troubleshooter
1. "docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]]."
  ```bash
  # Add NVIDIA package repositories
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  
  # Install the NVIDIA Docker package
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker
  ```
2. 
