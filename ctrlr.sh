#!/bin/zsh

echo "Running $(basename $0)"

PRJ_ROOT="$(cd $(dirname $0); pwd)"
PRJ_NAME="mqttclientjl-sandbox"
SCRIPT_D="$PRJ_ROOT/script"
DOCKERFILE="$PRJ_ROOT/Dockerfile"
DOCKER_IMG_NAME="$PRJ_NAME-img"
DOCKER_CONT_NAME="$PRJ_NAME-cont"
SRC_D="$PRJ_ROOT/mqttclient.jl"

[[ ! -d "$SRC_D" ]] && echo "No source for mqttclient.jl found at $SRC_D " && \
    echo "Exiting $(basename $0)" && \
    exit 1

[[ "$1" = "build" ]] && \
    docker build -t $DOCKER_IMG_NAME -f $DOCKERFILE .

# the GITHUB_ACTION env var prevents the smoke tests from running
[[ "$1" = "run" ]] && \
    docker run -it --rm \
    -e GITHUB_ACTION=0 \
    -v $(pwd)/.julia:/root/.julia \
    -v $PRJ_ROOT:/sandbox \
    --name $DOCKER_CONT_NAME \
    $DOCKER_IMG_NAME \
    julia run.jl

[[ "$1" = "clean" ]] && \
    docker image rm $DOCKER_IMG_NAME

echo "Exiting $(basename $0)"
