# build image dotnet logging test
docker build -t lognet-image -f ./lognet/Dockerfile ./lognet

# create deployment and service for lognet
kubectl create -f ./k8s/lognet/deployment.yml
kubectl create -f ./k8s/lognet/service.yml

# deploy elasticsearch
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install elasticsearch --set master.replicas=1,coordinating.service.type=LoadBalancer,data.replicas=1,coordinating.replicas=1,global.kibanaEnabled=true bitnami/elasticsearch

# setup fluentd
# TODO: CHECK THIS STEP
kubectl create -f ./k8s/fluentd/configmap.yaml
helm install fluentd bitnami/fluentd --set aggregator.configMap=elasticsearch-output --set aggregator.extraEnv[0].name=ELASTICSEARCH_HOST,aggregator.extraEnv[0].value=elasticsearch-master,aggregator.extraEnv[1].name=ELASTICSEARCH_PORT,aggregator.extraEnv[1].value=9200,forwarder.rbac.pspEnabled=true

# setup fluentbit
kubectl create -f ./k8s/fluentbit/namespace.yml
kubectl create -f ./k8s/fluentbit/serviceaccount.yml
kubectl create -f ./k8s/fluentbit/clusterrole.yml
kubectl create -f ./k8s/fluentbit/clusterrolebinding.yml
kubectl create -f ./k8s/fluentbit/configmap.yml
kubectl create -f ./k8s/fluentbit/daemonset.yml

