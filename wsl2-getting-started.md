<!-- markdownlint-disable MD013 -->
# Install WSL2

If needed, all course exercises can be carried out on a Windows 10 or 11 computer if [WLS2](https://learn.microsoft.com/en-us/windows/wsl/about#what-is-wsl-2) is installed.

Other setups _may_ work fine, e.g. running a VM with Linux or using PowerShell instead, but you are on your own with any problems that may arise.

The official installation instructions for WSL2 are found here:
<https://learn.microsoft.com/en-us/windows/wsl/install>

It is recommended that you install Ubuntu 22.04 (aka "Jammy"), which is currently the default for WSL2.

Historically WSL2 has worked best (wider feature support) for Windows 11 but there have been a series of back-ports to Windows 10 so that should also work for this course. But depending on Windows 10 version some of the installation instructions below may need adaptations so tell us if this is the case for you.

> ❗ ***NOTE:***
>
> If you don't have Windows Terminal on your computer already (default in Windows 11), we recommend that you install it and preferably _before_ installing WSL2.

### Enable `systemd` and fix DNS resolving

It is recommended that you configure WSL2 to use `systemd`. The details around this can be found in [this guide](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/) but the practical steps are included in the sequence below.

You will also change how `/etc/resolv.conf` is managed in WSL2, to avoid issues when running containers.

1. From within WSL2, make the following addition/change to `/etc/wsl.conf` (create the file it doesn't already exists):
    ```ini
    [network]
    generateResolvConf = false
    [boot]
    systemd=true
    ```
2. From within WSL2, run the following command
    ```shell
    sudo bash -c "unlink /etc/resolv.conf && echo 'nameserver 1.1.1.1' > /etc/resolv.conf"
    ```
3. From Windows' `CMD`:
    ```shell
    wsl --shutdown
    ```
4. From within WSL2, confirm correct setup:
    ```console
    $ nslookup google.com
      Server:         1.1.1.1
      Address:        1.1.1.1#53
        :

    $ systemctl list-unit-files --type=service
        :
      (a table with all services and their states)
    ```


## FAQ

### 1. DNS problems on WSL2

Microsoft have implemented a strategy for DNS resolving in WSL2 which does not play well with containers. The system creates a custom `/etc/resolv.conf`, which is pointing to the Windows host machine's DNS server. That is reachable from WSL2, but not from containers within WSL2 and since Docker will mount the (Linux) host's `resolv.conf` into each container, that breaks things.

In order to fix this, you should deactivate the automatic `resolv.conf` generation by WSL2 and manually create a good `resolv.conf`.

1. Ensure that the following is set in `/etc/wsl.conf`:

    ```ini
    [network]
    generateResolvConf = false
    ```

2. Restart WSL2 by running `wsl --shutdown` in PowerShell.

3. Edit `/etc/resolv.conf` and make sure there's some good Internet DNS servers there, e.g.:

    ```resolv
    # Cloudflare's DNS service 1.1.1.1:
    nameserver 1.1.1.1
    nameserver 1.0.0.1
    ```

### 2. Docker service is not running

If you haven't configured `systemd` for WSL2, the Docker service will not start automatically. To start it, you have to run `sudo service docker start`.

You can do this automatically by putting the following in your `~/.bashrc`:

```shell
# Check that the docker client is installed
if command -v docker &> /dev/null; then
    # Check if docker service exists
    if service --status-all |& grep -qE ' docker$'; then
        # Start the docker service unless it's already running
        if ! service docker status > /dev/null ; then
            echo "Service docker not running!"
            echo "service docker start ..."
            # sudo service docker start
        fi
    else
        echo "* service docker is missing"
    fi
fi
```

### 3. Multiple error printouts during WSL2 startup

    (`mount: /sys/fs/cgroup/cpuset: wrong fs type, bad option, ...`)

This problem may appear in some versions of WSL2, see this [GitHub issue](https://github.com/microsoft/WSL/issues/9868) for details.

It generally helps if you have enabled `systemd` according to above. You may also have to add the following to your `.wslconfig` file (in your home directory in Windows)

1. In `CMD`:
    ```shell
    notepad %USERPROFILE%\.wslconfig
    ```
2. Add:
    ```ini
    [wsl2]
    kernelCommandLine= cgroup_no_v1=all
    ```
3. In `CMD`:
   ```shell
    wsl --shutdown
    ```
