#!/bin/sh
if [ "$#" -ne 1 ]; then
	echo "Usage ./deploy.sh <version> Example ./deploy.sh 003"
else
  # push new docker container to Azure container registry
	az acr login --name kubeunity
	docker tag bind unitynetworks.tk.azurecr.io/bind:$1
	docker push unitynetworks.tk.azurecr.io/bind:$1

  # deploy new docker container
  kubectl set image deployment/ns1-deployment ns1=unitynetworks.tk.azurecr.io/bind:$1
  kubectl set image deployment/ns2-deployment ns2=unitynetworks.tk.azurecr.io/bind:$1
fi
