#!/bin/bash
docker rm $(docker ps -a -q -f status=exited)
docker rmi $(docker images -f "dangling=true" -q)
