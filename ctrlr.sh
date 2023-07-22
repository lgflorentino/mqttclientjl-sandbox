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

# the GITHUB_ACTION env var prevents the smoke tests from running
if [[ "$1" = "run" ]] ; 
then
    docker run -it --rm \
    -e GITHUB_ACTION=0 \
    -e UDS_TEST=$UDS_TEST \
    -v /tmp/mqtt/mqtt.sock:/tmp/mqtt/mqtt.sock \
    -v $(pwd)/.julia:/root/.julia \
    -v $PRJ_ROOT:/sandbox \
    --name $DOCKER_CONT_NAME \
    $DOCKER_IMG_NAME \
    julia run.jl "${@:2}"

elif [[ "$1" = "run-repl" ]];
then
    docker run -it --rm \
    -v /tmp/mqtt/mqtt.sock:/tmp/mqtt/mqtt.sock \
    -v $(pwd)/.julia:/root/.julia \
    -v $PRJ_ROOT:/sandbox \
    --name $DOCKER_CONT_NAME \
    $DOCKER_IMG_NAME \
    julia

elif [[ "$1" = "build" ]] ;
then
    docker build -t $DOCKER_IMG_NAME -f $DOCKERFILE .

elif [[ "$1" = "clean" ]] ;
then
    docker image rm $DOCKER_IMG_NAME
fi

echo "Exiting $(basename $0)"
exit 0

:<<COMMENT
Examples:
\$$(basename $0) run tests
UDS_TEST=true ./ctrlr.sh run tests
./ctrlr.sh run test uds_client
\$$(basename $0) run-repl
\$$(basename $0) clean
\$$(basename $0) build

COMMENT
