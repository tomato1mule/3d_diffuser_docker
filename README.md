# 3D_Diffuser_Docker

## Installation
```bash
sudo docker pull nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
sudo docker build -t 3diff:latest docker/.
bash docker/run_docker.sh
# Or you may mount local drive by bash docker/run_docker.sh --volume "<DIR_TO_YOUR_DATASET>:/root/3d_diffuser_actor/data"
# e.g., bash docker/run_docker.sh --volume "/mnt/disk2/data:/root/3d_diffuser_actor/data"
```

```bash
cd /DIR/TO/DATASET/ROOT
export CONTAINER_ID=<container_id> # run "docker ps" to find your container id

# Copy downloaded instructions.
docker cp instructions ${CONTAINER_ID}:/root/3d_diffuser_actor

# Copy downloaded dataset.
docker exec ${CONTAINER_ID} mkdir -p /root/3d_diffuser_actor/data/peract
docker cp data/peract/raw ${CONTAINER_ID}:/root/3d_diffuser_actor/data/peract

# Copy downloaded model params.
docker exec ${CONTAINER_ID} mkdir -p /root/3d_diffuser_actor/train_logs
docker cp diffuser_actor_peract.pth ${CONTAINER_ID}:/root/3d_diffuser_actor/train_logs/diffuser_actor_peract.pth
docker cp act3d_peract.pth ${CONTAINER_ID}:/root/3d_diffuser_actor/train_logs/act3d_peract.pth
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
