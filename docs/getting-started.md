## Creating Repositories via Backstage

To create a new GitHub repository using our template:

1. Navigate to the Backstage portal
2. Click "Create..." in the sidebar
3. Select "Create GitHub Repository"
4. Fill in the repository details:
   - Name: Your repository name
   - Description: A clear description of the repository's purpose
   - Private: Whether the repository should be private
   - Initialize: Whether to create an initial README
5. Click "Create" to submit

The template will:
1. Create a RepoClaim in the Kubernetes cluster
2. Crossplane will process the claim and create the GitHub repository
3. ArgoCD will begin monitoring the new repository
4. You can track progress in both Backstage and ArgoCD

### Viewing Repository Status

Once created, you can:
1. View the repository in the Backstage catalog
2. Click the ArgoCD link to see the sync status
3. Access the GitHub repository directly through the provided links 