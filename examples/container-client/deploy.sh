#!/bin/bash
sudo docker build -t ratnadeepb/ipc-client .
sudo docker push ratnadeepb/ipc-client:latest

sudo docker run -v /tmp:/tmp -d ratnadeepb/ipc-client:latest
