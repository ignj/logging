# create namespace
kubectl create namespace logging

# deploy elasticsearch
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm install --name elasticsearch stable/elasticsearch \
    --set master.persistence.enabled=false \
    --set data.persistence.enabled=false \
    --namespace logging

# deploy kibana
helm install --name kibana stable/kibana \
    --set env.ELASTICSEARCH_URL=http://elasticsearch-client:9200 \
    --namespace logging

# deploy fluentbit
## Create the RBAC resources for Fluent Bit
kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-service-account.yaml

kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role.yaml

kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role-binding.yaml

##Create the Fluent Bit Config Map
kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/output/elasticsearch/fluent-bit-configmap.yaml

##Deploy the Fluent Bit DaemonSet
wget https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/output/elasticsearch/fluent-bit-ds.yaml
# modify as recommended, then:
kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/output/elasticsearch/fluent-bit-ds.yaml

