# DEP DEMO

This project uses MkDocs for documentation and idpbuilder for development environment setup. For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Documentation with MkDocs

### MkDocs Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

### Mkdocs Layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## Development Environment

### Installing Go

This project requires Go. To install Go:

1. **Download Go**:
   Visit [go.dev/dl](https://go.dev/dl/) and download the latest version for your operating system, or use your package manager:

   ```bash
   # macOS with Homebrew
   brew install go

   # Linux with apt
   sudo apt-get update
   sudo apt-get install golang-go

   # Linux with yum
   sudo yum install golang
   ```

2. **Verify Installation**:
   ```bash
   go version
   ```

3. **Set up Go Environment** (if not already done):
   ```bash
   # Add these to your ~/.bashrc or ~/.zshrc
   export GOPATH=$HOME/go
   export PATH=$PATH:$GOPATH/bin
   ```

### Using Devbox

This project uses devbox for environment management. 
To get started:

1. **First Time Setup**:
   
   ```bash
   # Install devbox
   curl -fsSL https://get.jetpack.io/devbox | bash

   # Initialize devbox
   devbox init

   # Add nushell to devbox
   devbox add nu
   ```

2. **Regular Usage**:
  
   ```bash
   # Enter devbox environment
   devbox shell

   # Start nushell (optional)
   nu
   ```

### Using idpbuilder

This project uses idpbuilder to set up a complete internal developer platform. To get started:

1. **Install idpbuilder**:
   ```bash
   arch=$(if [[ "$(uname -m)" == "x86_64" ]]; then echo "amd64"; else uname -m; fi)
   os=$(uname -s | tr '[:upper:]' '[:lower:]')
   idpbuilder_latest_tag=$(curl --silent "https://api.github.com/repos/cnoe-io/idpbuilder/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
   curl -LO  https://github.com/cnoe-io/idpbuilder/releases/download/$idpbuilder_latest_tag/idpbuilder-$os-$arch.tar.gz
   tar xvzf idpbuilder-$os-$arch.tar.gz
   ```

2. **Note about kubectl**:
   idpbuilder requires kubectl but will automatically manage its installation:
   - If the required version of kubectl is missing, idpbuilder will download it
   - The download is architecture-specific (e.g., darwin/arm64 for Apple Silicon)
   - You don't need to manually install kubectl

3. **Create Development Environment**:
   ```bash
   ./idpbuilder create
   ```

## Running the Application

### Local Development
1. **Run the Go Application**:
   
    ```bash
    go run main.go
    ```
    The server will start at `http://localhost:8080`

2. **Build the Binary**:
    ```bash
    go build -o hello-world main.go
    ```

### Docker and Kind Cluster Deployment

1. **Build Docker Image**:
  
    ```bash
    docker build -t hello-world:latest .
    ```
2. **Run Docker Container locally**:
   
    ```bash
    docker run -p 8080:8080 hello-world:latest
    ```

### Kubernetes Deployment

1. **Create and Load into Kind Cluster**:
   
    ```bash
    # Create kind cluster
    kind create cluster

    # Load the image into kind
    kind load docker-image my-hello-world:latest
    ```

2. **Deploy to Kind Cluster**:
  
   ```bash
    # Apply the deployment and service
    kubectl apply -f deployent.yml

    # Verify deployment
    kubectl get pods
    kubectl get services
    ```

### Debugging in Kind

1. **Add Ephemeral Debug Container**:
    
    ```bash
    # Get the pod name
    kubectl get pods

    # Attach ephemeral debug container
    kubectl debug -it <pod-name> --image=alpine --target=hello
    ```

2. **Inside Debug Container**:
    
    ```bash
    # Install debugging tools
    apk add curl wget netcat-openbsd

    # Test service connectivity
    nc -zv hello-service 80

    # Make HTTP requests to service
    wget -q0- http://hello-service

    # Check process information
    ps aux

    # View network configuration
    ip addr
    ```

3. **Debugging Tips**:
    - The ephemeral container shares the same network namespace as the target container
    - You can access the same filesystem as the scratch container
    - Debug container is temporary and will be removed when the session ends
    - No changes to the original deployment are required

4. **Exit and Cleanup**:
   
    ```bash
    # Exit the debug session
    exit

    # The ephemeral container is automatically cleaned up
    ```

## Additional Resources

### Documentation
- MkDocs documentation: [mkdocs.org](https://www.mkdocs.org)
- idpbuilder documentation: [cnoe.io/docs](https://cnoe.io/docs/reference-implementation/installations/idpbuilder)

### Community Support

If you have questions about idpbuilder, you can:
- Join the [CNCF Slack Channel](https://cloud-native.slack.com/archives/C05TN9WFN5S)
- Attend community meetings (see [calendar](https://calendar.google.com/calendar/embed?src=064a2adfce866ccb02e61663a09f99147f22f06374e7a8994066bdc81e066986%40group.calendar.google.com&ctz=America%2FLos_Angeles))

# IDP Builder

Internal development platform binary launcher.

## About

Spin up a complete internal developer platform using industry standard technologies like Kubernetes, Argo, and backstage with only Docker required as a dependency.

This can be useful in several ways:
* Create a single binary which can demonstrate an IDP reference implementation.
* Use within CI to perform integration testing.
* Use as a local development environment for platform engineers.

## Getting Started

The easiest way to get started is to grab the idpbuilder binary for your platform and run it. You can visit our [nightly releases](https://github.com/cnoe-io/idpbuilder/releases/latest) page to download the version for your system, or run the following commands:

```bash
arch=$(if [[ "$(uname -m)" == "x86_64" ]]; then echo "amd64"; else uname -m; fi)
os=$(uname -s | tr '[:upper:]' '[:lower:]')


idpbuilder_latest_tag=$(curl --silent "https://api.github.com/repos/cnoe-io/idpbuilder/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -LO  https://github.com/cnoe-io/idpbuilder/releases/download/$idpbuilder_latest_tag/idpbuilder-$os-$arch.tar.gz
tar xvzf idpbuilder-$os-$arch.tar.gz
```

You can then run idpbuilder with the create argument to spin up your CNOE IDP:

```bash
./idpbuilder create
```

For more detailed information, checkout our [documentation website](https://cnoe.io/docs/reference-implementation/installations/idpbuilder) on getting started with idpbuilder.

## Community

- If you have questions or concerns about this tool, please feel free to reach out to us on the [CNCF Slack Channel](https://cloud-native.slack.com/archives/C05TN9WFN5S).
- You can also join our community meetings to meet the team and ask any questions. Checkout [this calendar](https://calendar.google.com/calendar/embed?src=064a2adfce866ccb02e61663a09f99147f22f06374e7a8994066bdc81e066986%40group.calendar.google.com&ctz=America%2FLos_Angeles) for more information.

## Contribution

Checkout the [contribution doc](./CONTRIBUTING.md) for contribution guidelines and more information on how to set up your local environment.


<!-- JUST BADGES & LINKS -->
[codespell-badge]: https://github.com/cnoe-io/idpbuilder/actions/workflows/codespell.yaml/badge.svg
[codespell-link]: https://github.com/cnoe-io/idpbuilder/actions/workflows/codespell.yaml

[e2e-badge]: https://github.com/cnoe-io/idpbuilder/actions/workflows/e2e.yaml/badge.svg
[e2e-link]: https://github.com/cnoe-io/idpbuilder/actions/workflows/e2e.yaml

[report-badge]: https://goreportcard.com/badge/github.com/cnoe-io/idpbuilder
[report-link]: https://goreportcard.com/report/github.com/cnoe-io/idpbuilder

[commit-activity-badge]: https://img.shields.io/github/commit-activity/m/cnoe-io/idpbuilder
[commit-activity-link]: https://github.com/cnoe-io/idpbuilder/pulse

## Troubleshooting
```bash
./idpbuilder create
May 12 15:17:36 INFO Creating kind cluster logger=setup 
May 12 15:17:36 INFO Cluster already exists logger=setup cluster=localdev 
May 12 15:17:36 INFO Adding CRDs to the cluster logger=setup 
May 12 15:17:37 INFO Setting up CoreDNS logger=setup 
May 12 15:17:37 INFO Setting up TLS certificate logger=setup 
May 12 15:17:37 INFO Creating localbuild resource logger=setup 
May 12 15:17:37 INFO Starting EventSource controller=gitrepository controllerGroup=idpbuilder.cnoe.io controllerKind=GitRepository source=kind source: *v1alpha1.GitRepository 
May 12 15:17:37 INFO Starting Controller controller=gitrepository controllerGroup=idpbuilder.cnoe.io controllerKind=GitRepository 
May 12 15:17:37 INFO Starting EventSource controller=custompackage controllerGroup=idpbuilder.cnoe.io controllerKind=CustomPackage source=kind source: *v1alpha1.CustomPackage 
May 12 15:17:37 INFO Starting Controller controller=custompackage controllerGroup=idpbuilder.cnoe.io controllerKind=CustomPackage 
May 12 15:17:37 INFO Starting EventSource controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild source=kind source: *v1alpha1.Localbuild 
May 12 15:17:37 INFO Starting Controller controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild 
May 12 15:17:37 INFO Starting workers controller=gitrepository controllerGroup=idpbuilder.cnoe.io controllerKind=GitRepository worker count=1 
May 12 15:17:37 INFO Starting workers controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild worker count=1 
May 12 15:17:37 INFO Starting workers controller=custompackage controllerGroup=idpbuilder.cnoe.io controllerKind=CustomPackage worker count=1 
May 12 15:17:40 INFO Waiting for Deployment ingress-nginx-controller to become ready controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:17:40 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:17:40 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=312eb209-10ab-4b70-842e-0c654c14e2fc 
May 12 15:17:45 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=23618a33-e667-4c10-83be-6f075ddc4145 
May 12 15:17:50 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=b3307fe6-7902-4468-a5ab-ae9572efb416 
May 12 15:17:55 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=38601389-ca33-4f02-bdac-71e5076d638e 
May 12 15:18:00 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=3a0ee6ae-79bb-457d-8b65-f4512ecda43e 
May 12 15:18:05 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=cf748906-f85d-400d-87c4-2f0bd41d8b0d 
May 12 15:18:10 INFO Waiting for Deployment ingress-nginx-controller to become ready controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:18:11 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=db09973b-9c86-4b0e-882b-72c1767c1b2f 
May 12 15:18:16 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=81aa75f4-1e13-4722-b83d-2e6c0c6e9512 
May 12 15:18:21 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=32855bab-f010-4f6b-83a9-fdf2b1c2a5c5 
May 12 15:18:26 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=66f1b7e6-800c-4b58-89a7-c81eb8245db6 
May 12 15:18:31 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=66ddc6f9-0f69-4c84-a693-cbeae97335ec 
May 12 15:18:36 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=e714b62e-5eca-4827-b562-0d711033fd86 
May 12 15:18:40 INFO Waiting for Deployment ingress-nginx-controller to become ready controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:18:41 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=c3f03f71-6d67-4dee-b35d-181d209e624f 
May 12 15:18:46 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=ccf32d4c-4bd4-4b55-94f1-1c4d6866f46e 
May 12 15:18:51 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=5a3d845f-22dd-4135-b943-01cc54dac754 
May 12 15:18:56 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=d7331f55-4033-4048-97a7-c5310a4d1c3d 
May 12 15:19:01 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=fdc139cb-cbd3-43c0-8750-e878ec08ec6b 
May 12 15:19:06 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=1178ed0e-005f-46ef-b132-226041351388 
May 12 15:19:10 INFO Waiting for Deployment ingress-nginx-controller to become ready controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:19:11 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=9cd74d94-37d6-4174-82e1-d56062df738c 
May 12 15:19:16 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=fb975096-cff1-40c5-8f3a-6d6f7384ecfe 
May 12 15:19:21 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=0a701c5f-8bcc-4f05-97cb-ab7ff325c65d 
May 12 15:19:26 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=7d8ffba6-9b3a-45dc-bafa-7a8bba8e2879 
May 12 15:19:31 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=e719f332-2641-4081-a417-692ba556ff09 
May 12 15:19:36 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=799713a2-94f7-4005-bf4b-b04511f73118 
May 12 15:19:40 INFO Waiting for Deployment ingress-nginx-controller to become ready controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=6eb4ab94-1d9f-4044-99c1-273f8ee8d97e 
May 12 15:19:41 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=c62fa1aa-b590-4e94-98de-1f0a0a75b1fb 
May 12 15:19:46 INFO Checking if we should shutdown controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild name=localdev name=localdev reconcileID=4c09456f-16d0-4815-a9ae-34c5cb8af82a 
^CMay 12 15:19:49 INFO Stopping and waiting for non leader election runnables 
May 12 15:19:49 INFO Stopping and waiting for leader election runnables 
May 12 15:19:49 INFO Shutdown signal received, waiting for all workers to finish controller=custompackage controllerGroup=idpbuilder.cnoe.io controllerKind=CustomPackage 
May 12 15:19:49 INFO All workers finished controller=custompackage controllerGroup=idpbuilder.cnoe.io controllerKind=CustomPackage 
May 12 15:19:49 INFO Shutdown signal received, waiting for all workers to finish controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild 
May 12 15:19:49 INFO Shutdown signal received, waiting for all workers to finish controller=gitrepository controllerGroup=idpbuilder.cnoe.io controllerKind=GitRepository 
May 12 15:19:49 INFO All workers finished controller=gitrepository controllerGroup=idpbuilder.cnoe.io controllerKind=GitRepository 
May 12 15:19:49 INFO All workers finished controller=localbuild controllerGroup=idpbuilder.cnoe.io controllerKind=Localbuild 
May 12 15:19:49 INFO Stopping and waiting for caches 
May 12 15:19:49 INFO Stopping and waiting for webhooks 
May 12 15:19:49 INFO Stopping and waiting for HTTP servers 
May 12 15:19:49 INFO Wait completed, proceeding to shutdown the manager 
Error: command interrupted
command interrupted
~/DEP Demo> kubectl get pods -n ingress-nginx
I0512 15:20:04.155552   50166 versioner.go:119] Right kubectl missing, downloading version 1.31.4
Downloading https://dl.k8s.io/release/v1.31.4/bin/darwin/arm64/kubectl
kubectl1.31.4 100% |████████████████████████████████████████| (57/57 MB, 986 kB/s) done.         
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-fhbwq        0/1     Completed   0          3m22s
ingress-nginx-admission-patch-md56j         0/1     Completed   0          3m22s
ingress-nginx-controller-795dfd6796-kwrxv   1/1     Running     0          3m22s
~/DEP Demo>                                                                      05/12/2025 03:21:02 PM