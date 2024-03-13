#!/bin/bash

# Default values
volume=""
gpu="all"

# Parse named arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --volume)
      volume="-v $2"
      shift # past argument
      shift # past value
      ;;
    --gpu)
      gpu="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      shift # past argument
      ;;
  esac
done

echo "Volume: $volume"
echo "GPU: $gpu"

xhost local:docker

docker run \
--privileged \
--gpus "$gpu" \
-e DISPLAY=$DISPLAY \
-e "TERM=xterm-256color" \
--device /dev/dri \
--net=host \
$volume \
-it \
3diff:latest