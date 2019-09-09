#!/usr/bin/env bash

# Get GKE credential
if [[ -n "$GKE_CLUSTER_ZONE" ]]; then
  gcloud container clusters get-credentials --project $GCP_PROJECT_NAME --zone $GKE_CLUSTER_ZONE $GKE_CLUSTER_NAME
else
  gcloud container clusters get-credentials --project $GCP_PROJECT_NAME --region $GKE_CLUSTER_REGION $GKE_CLUSTER_NAME
fi

# Calculate old date (default telepresence max age is 24h)
TELE_MAX_AGE_HOURS=${TELE_MAX_AGE_HOURS:-24}
CUR_DATETIME=`date +%s`
OLD_DATE=`date -d @"$(($CUR_DATETIME - 60*60*TELE_MAX_AGE_HOURS))" +%FT%TZ`

# Clear old telepresence deployments
kubectl get deploy --all-namespaces \
  -l telepresence \
  -o custom-columns=namespace:.metadata.namespace,name:.metadata.name,age:.metadata.creationTimestamp \
  | awk -v oldDate=$OLD_DATE \
  '{if ($3 < oldDate) system("kubectl delete deploy --grace-period=0 -n " $1 " " $2) }'

# Succeed
exit 0
