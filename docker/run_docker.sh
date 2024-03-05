xhost local:docker

docker run \
--privileged \
--gpus all \
-e DISPLAY=$DISPLAY \
-e "TERM=xterm-256color" \
--device /dev/dri \
--net=host \
-it \
3diff:latest