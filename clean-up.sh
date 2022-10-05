#!/bin/sh
DELETE_LIST='ContainerStatusUnknown|Evicted|Completed|NodeAffinity|Error'

for var in "$@"
do
   DELETE_LIST=${DELETE_LIST//\|$var/}
   DELETE_LIST=${DELETE_LIST//$var\|/}
done

echo "Will be deleting pods that match this list $DELETE_LIST"

for namespace in $(kubectl get namespace -o=json |  jq -r '.items[] .metadata.name') ; do
  echo "Processing namespace ${namespace}"
  kubectl -n ${namespace} get pods | grep -E $DELETE_LIST | awk '{print $1}' | xargs --no-run-if-empty kubectl delete pod -n ${namespace}
done