#!/bin/bash

# 部署监控对象
object=apache

helm install $object-v2-4 --namespace $object -f ./values/bitnami_values.yaml ./$object \
  --set image.tag='2.4' \
  --set commonLabels.object_version=v2-4 \
  --set service.nodePorts.http=31080 \
  --set service.nodePorts.https=31443

