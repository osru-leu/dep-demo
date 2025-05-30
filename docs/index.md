# DEP DEMO

This project uses MkDocs. For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## MkDocs Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Mkdocs layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

# Dep Demo

## Development Environment

### Using Devbox

This project uses devbox for development environment management. 
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

### Debugging Scrachg Container in Kind

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
    - The ephmeral container shares the same network namespace as the target container
    - You can access the same filesystem as the scratch container
    - Debug container is temporary and will be removed when the session ends
    - No changes to the original deployment are required

4. **Exit and Cleanup**:
   
    ```bash
    # Exit the debug session
    exit

    # The ephemeral contaier is automatically cleaned up
    ```
