# Install dependencies

If you have a clean install of Ubuntu 22.04 (bare metal or within in WSL2), the simplest way of installing all dependencies (tools) is to run the `install-all.sh` script found under `env-prep/` in the root of this repo.

```shell
cd env-prep
./install-all.sh
```

(The script will run some commands with `sudo`, so you may have to enter your password at some point during the script execution)

If you have another Linux distribution (or existing Ubuntu 22.04) on your computer, which already have a some of the tools installed, you may want to install each missing dependency manually according to the sub-sections below. You can also inspect the scripts under `env-prep/` for details if you like.

## Manual installation

>❗ **NOTE:** Skip these steps if you ran the `install-all.sh` script. Otherwise proceed but, if possible, try not to install dependencies as a root user.

### Install Docker

1. Install Docker as described in the official documentation: <https://docs.docker.com/engine/install/ubuntu/>
2. Start the Docker service.

### Install `helm`

Helm: <https://helm.sh/docs/intro/install/>

### Install `kubectl`

Follow this guide: <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/>

### Install `k3d`

You will be using `k3d` to setup a local Kubernetes cluster on your machine. `k3d` is a lightweight wrapper around the minimal Kubernetes distribution called `k3s`.

Installation instructions are found here: <https://k3d.io/#installation>
