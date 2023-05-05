#!/bin/bash

dversion=1.2
se -e

docker tag 1clickeck-client sunmanreg.azurecr.io/sunmanreg.azurecr.io/1clickeck-client:${dversion}
docker tag sunmanreg.azurecr.io/1clickeck-client:${dversion}sunmanreg.azurecr.io/1clickeck-client:latest
docker push sunmanreg.azurecr.io/1clickeck-client:${dversion}
docker push sunmanreg.azurecr.io/1clickeck-client:latest