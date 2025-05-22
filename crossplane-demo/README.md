## Create kind cluster
```bash
kind create cluster --name crossplane-demo
```

#### Get context
```bash
kubectl config current-context
```

#### Deleting a cluster
```bash
kind delete cluster --name crossplane-demo
```
#### Get clusters
```bash
kind get clusters
```

### Configure Crossplane Helm repository
```bash
helm repo add crossplane-stable https://charts.crossplane.io/stable
```
#### Update repos
```bash
helm repo update
```
### Install Crossplane
```bash
helm install crossplane \
  --namespace crossplane-system \
  --create-namespace \
  crossplane-stable/crossplane
```
  #### Result:
  ```bash
    NAME: crossplane
    LAST DEPLOYED: Mon May 19 09:46:07 2025
    NAMESPACE: crossplane-system
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    Release: crossplane

    Chart Name: crossplane
    Chart Description: Crossplane is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume.
    Chart Version: 1.19.1
    Chart Application Version: 1.19.1
```

### Check status
```bash
helm list -n crossplane-system
```
### Upgrade
```bash
helm upgrade crossplane crossplane-stable/crossplane
```
### Uninstall
```bash
helm uninstall crossplane -n crossplane-system
```
## View installed crossplane pods
```bash
kubectl get pods -n crossplane-system
```

## Apply composite resource definition
```bash
kubectl apply -f <path/to/xrd.yaml>
kubectl get compositeresourcedefinitions
```
## Apply composition
```bash
kubectl apply -f <path/to/composition.yaml>
kubectl get composition
```
## Apply claim
```bash
kubectl apply -f <path/to/claim.yaml>
```
### Get your claims
```bash
kubectl get <claims>
```

### Get composite resources created by claims
```bash
kubectl get <composites>
```
