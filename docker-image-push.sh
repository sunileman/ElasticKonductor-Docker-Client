#!/bin/bash

dversion=1.3
se -e

docker build -t 1clickeck-client .

docker tag 1clickeck-client sunmanreg.azurecr.io/sunmanreg.azurecr.io/1clickeck-client:${dversion}
docker tag sunmanreg.azurecr.io/1clickeck-client:${dversion}sunmanreg.azurecr.io/1clickeck-client:latest
docker push sunmanreg.azurecr.io/1clickeck-client:${dversion}
docker push sunmanreg.azurecr.io/1clickeck-client:latest