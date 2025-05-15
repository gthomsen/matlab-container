# Overview
Tools for building customer containers on top of MathWorks' MATLAB container.
This exists to allow running the MathWorks' containers with a named network
license without setting up a local license server instance.

This repository contains:
- A `Dockerfile` for building a custom MATLAB container
- A `matlab-container` wrapper shell script to launch the custom container with
  a license file on the host

***NOTE:*** The provided `matlab-container` script requires host networking to
be used, so as to expose an network interface with the correct MAC into the
container.  Without this, a license server *MUST* be used.

# Building the Container
This builds a container suitable for use by the user running the command:

```shell
$ podman build \
    -f Dockerfile \
    --build-arg USER_NAME=${USER} \
    -t personal-matlab:r2024b \
    .
```

This builds the `personal-matlab:r2024b` image.

# Preparing the License
Activate and download the MATLAB license through your [MathWorks
account](https://www.mathworks.com/login).  The `matlab-container` script
assumes that it is installed in `${HOME}/matlab2024b/license.lic`.

# Running the Container
The `matlab-container` script launches the customized container with the host's license
mapped.  It also sets the `DISPLAY` variable inside of the container so that
MATLAB graphics are available via VNC.  By default, `DISPLAY=:102` is used (port
6002 on the host) though the script takes the value of `DISPLAY` as an optional
argument:

```shell
# VNC is running on DISPLAY=:102
(host) $ matlab-container

# VNC is running on DISPLAY=:3
(host) $ matlab-container :3
```

## Running MATLAB Inside the Container
The VNC server needs to be running before launching MATLAB (unless started with
the `-nodesktop` option):

```shell
$ vncserver -geometry 1600x1200 :102
```

The default VNC password is `matlab` as set in the upstream MathWorks container.
Change the VNC server's window size (`1600x1200` above) and `DISPLAY` (`:102`
above) as appropriate.

MATLAB is launched inside of the container via the `matlab` command.  By
default this launches the MATLAB Desktop which will display on the currently
set display (via the `DISPLAY` environment variable).

# Motivation
All of the [MathWorks MATLAB container
documentation](https://hub.docker.com/r/mathworks/matlab) indicates that either
a license server is required or for the license file to be provided directly
to the container.  Try as I might, I couldn't get specifying the license
directly in the container to work with Podman without the above approach.

Installing a Mathworks license server was undesirable since its installation
process requires an absurd number of dependencies unsuitable for a headless
server (i.e. installing a graphical desktop and printer daemon).
