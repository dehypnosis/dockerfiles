# Utility Dockerfiles

### 1. gcr.io/qmit-pro/gcp-kubectl
Build
```bash
docker build ./gcp-kubectl -t gcr.io/qmit-pro/gcp-kubectl
docker push gcr.io/qmit-pro/gcp-kubectl
```

### 2. gcr.io/qmit-pro/gke-clear-old-telepresence-deployments
Build
```bash
docker build ./gke-clear-old-telepresence-deployments -t gcr.io/qmit-pro/gke-clear-old-telepresence-deployments
docker push gcr.io/qmit-pro/gke-clear-old-telepresence-deployments
```

Env
- TELE_MAX_AGE_HOURS: 24
- GCP_PROJECT_NAME: qmit-pro
- GKE_CLUSTER_ZONE: asia-northeast1-a
- GKE_CLUSTER_REGION: (for regional cluster)
- GKE_CLUSTER_NAME: dev (prod, ...)

Usage
```bash
# Cannot be authorized locally
docker run \
    -e GCP_PROJECT_NAME=qmit-pro \
    -e GKE_CLUSTER_ZONE=asia-northeast1-a \
    -e GKE_CLUSTER_NAME=dev \
    gcr.io/qmit-pro/gke-clear-old-telepresence-deployments

# So, Run pod inside GKE with proper service account (can use tiller if have)
kubectl run \
    --generator=run-pod/v1 \
    --image gcr.io/qmit-pro/gke-clear-old-telepresence-deployments \
    -it --rm --restart=Never \
    --namespace kube-system --serviceaccount tiller \
    --env GCP_PROJECT_NAME=qmit-pro \
    --env GKE_CLUSTER_ZONE=asia-northeast1-a \
    --env GKE_CLUSTER_NAME=dev \
    telepresence-clearing-job

# Or create CronJob
kubectl --context dev apply -f ./gke-clear-old-telepresence-deployments/telepresence-clearing-job.dev.yaml
kubectl --context prod apply -f ./gke-clear-old-telepresence-deployments/telepresence-clearing-job.prod.yaml

# Manual running example with existing CronJob
kubectl --context dev create job -n kube-system --from=cronjob/telepresence-clearing-job telepresence-clearing-job-001
```
