#!/bin/#!/usr/bin/env bash
set -e

#helm deploy
namespace=argotest
DeployName=test2
if helm repo list | grep -q argo; then
    echo argo repo found
else
    echo argo repo not found
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
fi

# argocd cli
brew tap argoproj/tap
brew install argoproj/tap/argocd


kubectl create namespace ${namespace}
kubectl apply -f psp -n ${namespace}
helm install ${DeployName} argo/argo-cd -f values.yaml -n ${namespace}

#connect to argo pod
ArgoCdServer=$(kubectl get pods -n ${namespace} -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo "UserName to log in is admin and the Password is ${ArgoCdServer}\nUserName:admin\nPassword:${ArgoCdServer}"
#kubectl port-forward svc/${DeployName}-argocd-server -n ${namespace} 8080:443



# raw yaml quick deploy demo
#https://github.com/argoproj/argo-cd/blob/master/docs/getting_started.md
#kubectl create namespace argocd
#kubectl apply -f psp --namespace argocd
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
#kubectl port-forward svc/argocd-server -n argocd 8080:443
