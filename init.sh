#!/bin/#!/usr/bin/env bash
set -e

#helm deploy
namespace=argo

if helm repo list | grep -q argo; then
    echo argo repo found
else
    echo argo repo not found
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
fi


kubectl create namespace ${namespace}
kubectl apply -f psp --namespace ${namespace}
helm install argo-test2 argo/argo-cd -f values.yaml --namespace ${namespace}

# raw yaml quick deploy demo
#kubectl create namespace argocd
#kubectl apply -f psp --namespace argocd
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
