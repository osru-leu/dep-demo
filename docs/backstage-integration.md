# Backstage Integration with Crossplane and idpbuilder

This guide walks through setting up a complete integration between Backstage, Crossplane, and idpbuilder for managing GitHub repositories through a GitOps workflow.

## Prerequisites

- kubectl installed
- kind installed
- helm installed
- GitHub Personal Access Token with repo permissions
- idpbuilder installed

## Step-by-Step Setup

### 1. Create Kind Cluster

```bash
# Create a new kind cluster
kind create cluster --name backstage-demo

# Verify the cluster is running
kubectl cluster-info --context kind-backstage-demo
```

### 2. Install Crossplane

```bash
# Add the Crossplane Helm repository
helm repo add crossplane-stable https://charts.crossplane.io/stable

# Update Helm repositories
helm repo update

# Install Crossplane
helm install crossplane \
  --namespace crossplane-system \
  --create-namespace \
  crossplane-stable/crossplane

# Verify Crossplane installation
kubectl get pods -n crossplane-system
```

### 3. Install idpbuilder

```bash
# Download the latest idpbuilder release
arch=$(if [[ "$(uname -m)" == "x86_64" ]]; then echo "amd64"; else uname -m; fi)
os=$(uname -s | tr '[:upper:]' '[:lower:]')
idpbuilder_latest_tag=$(curl --silent "https://api.github.com/repos/cnoe-io/idpbuilder/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -LO  https://github.com/cnoe-io/idpbuilder/releases/download/$idpbuilder_latest_tag/idpbuilder-$os-$arch.tar.gz
tar xvzf idpbuilder-$os-$arch.tar.gz

# Create development environment (this installs CRDs)
./idpbuilder create

# Verify idpbuilder installation
kubectl get crds | grep idpbuilder
```

### 4. Set Up Backstage Components

#### Create Namespace and RBAC
```bash
# Apply namespace and RBAC configuration
kubectl apply -f kubernetes/backstage/namespace.yaml
```

#### Configure Secrets
```bash
# Set your GitHub token
export GITHUB_TOKEN=your_github_token

# Apply secrets
./kubernetes/backstage/apply-secrets.sh
```

#### Apply Backstage ConfigMap
```bash
# Apply the Backstage configuration
kubectl apply -f kubernetes/backstage/config.yaml
```

### 5. Configure GitHub Repository Template

```bash
# Apply the CustomPackage template
kubectl apply -f kubernetes/idpbuilder/github-template.yaml
```

## Configuration Files

### Backstage ConfigMap (`kubernetes/backstage/config.yaml`)
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-config
  namespace: backstage
data:
  app-config.yaml: |
    app:
      title: Backstage
      baseUrl: http://localhost:7007
    # ... rest of the configuration
```

### GitHub Template (`kubernetes/idpbuilder/github-template.yaml`)
```yaml
apiVersion: idpbuilder.cnoe.io/v1alpha1
kind: CustomPackage
metadata:
  name: github-repo-template
spec:
  source:
    git:
      url: https://github.com/osru-leu/dep-demo.git
      # ref: main # default
      ref: feat/backstage-with-cnoe
      path: crossplane-resources
  # ... rest of the configuration
```

## Verification Steps

1. Check all resources in the backstage namespace:
```bash
kubectl get all -n backstage
```

2. Verify Crossplane resources:
```bash
kubectl get providers
kubectl get compositions
kubectl get managed
```

3. Check idpbuilder resources:
```bash
kubectl get custompackages
```

## Troubleshooting

### Common Issues

1. **Namespace not found**
   ```bash
   kubectl create namespace backstage
   ```

2. **CRDs not installed**
   ```bash
   kubectl get crds | grep idpbuilder
   kubectl get crds | grep crossplane
   ```

3. **Secret issues**
   - Verify GITHUB_TOKEN is set: `echo $GITHUB_TOKEN`
   - Check secret exists: `kubectl get secrets -n backstage`

## Notes

- The configuration uses the `feat/backstage-with-cnoe` branch
- Default values are commented in the configuration files for reference
- Make sure to keep your GitHub token secure and never commit it to version control 