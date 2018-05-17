#!/bin/bash

export $(cat .env | grep -v ^# | xargs) && envsubst < ./values.yaml > values.gen.yml

helm install --name mysb-helm -f ./values.gen.yml .
