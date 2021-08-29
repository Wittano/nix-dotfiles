#!/usr/bin/env bash
set -euo pipefail

sudo docker container ls --all | awk '{if($1 != "CONTAINER"){print $1}}' | xargs sudo docker container rm || echo 'Empty'
sudo docker images | awk '{if($3 != "IMAGE"){print $3}}' | xargs sudo docker rmi --force
