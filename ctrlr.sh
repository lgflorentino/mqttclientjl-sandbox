#!/bin/zsh

echo "Running $(basename $0)"

PRJ_ROOT="$(cd $(dirname $0); pwd)"
PRJ_NAME="mqttclientjl-sandbox"
SCRIPT_D="$PRJ_ROOT/script"
DOCKERFILE="$PRJ_ROOT/Dockerfile"
DOCKER_IMG_NAME="$PRJ_NAME-img"
DOCKER_CONT_NAME="$PRJ_NAME-cont"


[[ "$1" = "build" ]] && \
    docker build -t $DOCKER_IMG_NAME -f $DOCKERFILE .

[[ "$1" = "run" ]] && \
    docker run -it --rm \
    -v $PRJ_ROOT:/sandbox \
    --name $DOCKER_CONT_NAME \
    $DOCKER_IMG_NAME \
    julia run.jl

[[ "$1" = "clean" ]] && \
    docker image rm $DOCKER_IMG_NAME

echo "Exiting $(basename $0)"
