#!/bin/bash

VERSION=$(<VERSION)
IMAGE_NAME=homebridge-v$VERSION
ACTION=$1

if [ -z "$ACTION" ];
  then
    echo "usage: $0 <build|run|stop|start|remove|rerun|attach|logs";
    exit 1;
fi

_build() {
  # Build
  docker build --tag="patrickbusch/homebridge:$VERSION" .
}

_run() {
  # Run (first time)
  docker run -d -p 0.0.0.0:51826:51826 --name $IMAGE_NAME patrickbusch/homebridge:$VERSION
}

_stop() {
  # Stop
  docker stop $IMAGE_NAME
}

_start() {
  # Start (after stopping)
  docker start $IMAGE_NAME
}

_remove() {
  # Remove
  docker rm $IMAGE_NAME
}

_rerun() {
  _stop
  _remove
  _run
}

_attach() {
  docker exec -ti $IMAGE_NAME bash
}

_logs() {
  docker logs $IMAGE_NAME
}

eval _$ACTION
