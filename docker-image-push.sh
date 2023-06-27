#!/bin/bash

dversion=1.4
se -e

docker build -t elastickondoctor-client .

docker tag elastickondoctor-client:latest sunmanreg.azurecr.io/elastickondoctor-client:${dversion}
docker tag sunmanreg.azurecr.io/elastickondoctor-client:${dversion} sunmanreg.azurecr.io/elastickondoctor-client:latest
docker push sunmanreg.azurecr.io/elastickondoctor-client:${dversion}
docker push sunmanreg.azurecr.io/elastickondoctor-client:latest