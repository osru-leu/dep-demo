# GitOps Crossplane Demo

This demo shows how to use Crossplane to provision GitHub repositories through a GitOps workflow with ArgoCD.

## Prerequisites

- A running Kubernetes cluster (kind)
- Crossplane installed
- ArgoCD installed
- GitHub account with permissions to create repositories

## GitHub Token Setup

1. Create a Personal Access Token (PAT) in GitHub:
   - Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token" → "Generate new token (classic)"
   - Name it something like "crossplane-demo"
   - Select these permissions:
     - `repo` (all repository permissions)
   - Copy the token immediately after creation (you won't see it again!)

2. Create the secret in your cluster:
```bash
export GITHUB_TOKEN='your-github-pat-here'
kubectl create secret generic github-creds \
  -n crossplane-system \
  --from-literal=credentials="{\"token\":\"$GITHUB_TOKEN\"}"
```

## Configuration Files

- `crossplane-resources/`
  - `provider-config.yaml`: Configures the GitHub provider (references the secret)
  - `repo-definition.yaml`: Defines the RepoClaim custom resource
  - `repo-composition.yaml`: Maps RepoClaim fields to GitHub repository settings
  - `repo-claim.yaml`: Example repository claim
- `argocd/`
  - `application.yaml`: ArgoCD application configuration

## Security Note

The GitHub PAT is sensitive and should NEVER be committed to any repository. The secret is created directly in the cluster and referenced by the provider configuration. 