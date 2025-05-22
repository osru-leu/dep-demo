# Detailed Architecture and YAML Relationships

## YAML Configuration Flow

```mermaid
graph TD
    subgraph "GitHub Authentication"
        secret[Secret: github-creds] -->|Referenced by| pconfig[provider-config.yaml]
        pconfig -->|Configures| provider[GitHub Provider]
    end

    subgraph "Custom Resource Definition"
        xrd[repo-definition.yaml] -->|Defines| repocrd[RepoClaim CRD]
        xrd -->|Defines| xrepo[XRepository CRD]
    end

    subgraph "Resource Mapping"
        comp[repo-composition.yaml] -->|Implements| xrepo
        comp -->|Uses| provider
        comp -->|Maps Fields To| ghrepo[GitHub Repository Resource]
    end

    subgraph "GitOps Configuration"
        argo[application.yaml] -->|Watches| git[Git Repository]
        git -->|Contains| claim[repo-claim.yaml]
        claim -->|Creates| repocrd
    end

    subgraph "Resource Creation Flow"
        claim -->|Creates| xrepo
        xrepo -->|Processed by| comp
        comp -->|Creates| ghrepo
        ghrepo -->|Results in| final[Actual GitHub Repository]
    end

    style secret fill:#FF9999,color:#000000
    style pconfig fill:#FFB366,color:#000000
    style provider fill:#FFE5CC,color:#000000
    style xrd fill:#99FF99,color:#000000
    style comp fill:#99FFFF,color:#000000
    style claim fill:#FF99FF,color:#000000
    style argo fill:#FFA500,color:#000000
    style final fill:#0763e5,color:#000000

    %% Add field mapping details
    subgraph "Field Mappings in repo-composition.yaml"
        comp -->|"spec.name → spec.forProvider.name"| ghrepo
        comp -->|"spec.description → spec.forProvider.description"| ghrepo
        comp -->|"spec.private → spec.forProvider.visibility"| ghrepo
        comp -->|"spec.autoInit → spec.forProvider.autoInit"| ghrepo
    end
```

## YAML File Relationships

### Authentication Flow
- `github-creds` secret contains the GitHub PAT
- `provider-config.yaml` references this secret
- GitHub Provider uses this configuration for authentication

### Resource Definition Flow
- `repo-definition.yaml` (XRD) defines:
  - The RepoClaim custom resource
  - The XRepository composite resource
  - Available fields and their types

### Composition Flow
- `repo-composition.yaml`:
  - References the XRD
  - Maps RepoClaim fields to GitHub repository fields
  - Specifies transformations (e.g., boolean to string)
  - Sets default values

### GitOps Flow
- `application.yaml`:
  - Configures ArgoCD to watch the Git repository
  - Specifies which resources to sync
  - Defines sync behavior and frequency

### Claim Flow
- `repo-claim.yaml`:
  - Uses the custom resource definition
  - Specifies desired repository properties
  - Triggers the creation process 