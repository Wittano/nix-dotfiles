#!/usr/bin/env bash
set -euo pipefail

sudo docker container ls -aq | xargs sudo docker container rm || echo 'Empty'
sudo docker images -aq | xargs sudo docker rmi -f
