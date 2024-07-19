#!/bin/bash -x
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/operator
kubectl create namespace postgres
kubectl apply -k ./

cd $SCRIPT_DIR/db-instance

kubectl apply -k ./