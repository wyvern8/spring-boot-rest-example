#!/bin/bash

export $(cat .env | grep -v ^# | xargs) && envsubst < ./values.yaml > values.gen.yml

helm upgrade mysb -f ./values.gen.yml .
