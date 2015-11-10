# Table of Contents

- [Supported tags](#supported-tags)
- [Introduction](#introduction)
    - [Collecting information](#collecting-information)
        - [Docker inspect](#docker-inspect)
        - [Docker stats](#docker-stats)
        - [Docker top](#docker-top)
        - [Docker events](#docker-events)
    - [Version](#version)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Known issues](#known-issues)

## Supported tags

- `latest`

## Introduction

> NOTE: I'm working at Splunk, but this is not an official Splunk images.
> I build them in my free time when I'm not at work. I have some knowledge
> about Splunk, but you should think twice before putting them in
> production. I run these images on my own home server just for
> my personal needs. If you have any issues - feel free to open a
> [bug](https://github.com/outcoldman/docker-stats-splunk-forwarder/issues).

Dockerfile to build Splunk Universal Forwarder with preconfigured scripts
which monitors Docker host. It uses official docker client to read statistics
and information about containers from mounted docker unix socket. Mounting
`/var/run/docker.sock` from the host is required.

This image works great with [docker-stats-splunk](https://hub.docker.com/r/outcoldman/docker-stats-splunk/).

### Collecting information

#### Docker inspect

Once in 5 minutes `docker inspect` is executed for all containers (running and
not running). Data is getting recorded in JSON format. See [docker inspect](https://docs.docker.com/reference/commandline/inspect/).

#### Docker stats

Once in 5 seconds `docker stats` is executed for all running containers.
Data is getting recorded in CSV format with fields `container_id`,
`cpu_percent`, `mem_usage`, `mem_limit`, `mem_percent`, `net_input`,
`net_output`. See [docker stats](https://docs.docker.com/reference/commandline/stats/).

#### Docker top

Once in 5 minutes `docker top` is executed for all running containers.
Data is getting recorded in CSV format with fields `time`, `container_id`,
`pid`, `ppid`, `pgid`, `pcpu`, `vsz`, `nice`, `etime`, `time`, `tty`, `ruser`,
`user`, `rgroup`, `group`, `comm`, `args`. See `man ps` for information
about fields, and [docker top](https://docs.docker.com/reference/commandline/top/).

#### Docker events

All events from `docker events` are streamed. See [docker events](https://docs.docker.com/reference/commandline/events/)
for more details.

## Version

- Docker version: `1.9`
- Splunk Universal Forwarder: `6.3.1`

## Installation

Pull the image from the [docker registry](https://registry.hub.docker.com/u/outcoldman/docker-stats-splunk-forwarder/).
This is the recommended method of installation as it is easier to update image.
These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull outcoldman/docker-stats-splunk-forwarder:latest
```

Or you can pull latest version.

```bash
docker pull outcoldman/docker-stats-splunk-forwarder:latest
```

Alternately you can build the image locally.

```bash
git clone https://github.com/outcoldman/docker-stats-splunk-forwarder.git
cd docker-stats-splunk-forwarder
docker build --tag="$USER/docker-stats-splunk-forwarder" .
```

## Quick Start

To manually start container

```bash
docker run --hostname docker \
    --name docker_stats_splunk_forwarder \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    -e "SPLUNK_FORWARD_SERVER=splunk_indexer:9997" \
    -d outcoldman/docker-stats-splunk-forwarder:latest
```

> Container hostname will be used in the host field of all forwarded events.

I recommend you to start with [docker-stats-splunk](https://hub.docker.com/r/outcoldman/docker-stats-splunk/)
to see the benefits of collected data.

## Configuration

- `SPLUNK_FORWARD_SERVER` - specify connection to the Splunk indexer.

See [docker-splunk](https://github.com/outcoldman/docker-splunk) for more details.

## Known issues

Depending on the permissions you have for your `/var/run/docker.sock` *splunk*
user may now have permissions to access it. To debug this issue, just open new
iterative shell in container

```bash
docker exec -it your_container_name bash
```

After that check the `$SPLUNK_HOME\var\log\splunk\splunkd.log`, if you will see
something similar to

```text
11-10-2015 17:14:26.993 +0000 ERROR ExecProcessor - message from "/opt/splunk/etc/apps/docker/bin/docker_events.sh" Cannot connect to the Docker daemon. Is the dock er daemon running on this host?
11-10-2015 17:14:27.990 +0000 ERROR ExecProcessor - message from "/opt/splunk/etc/apps/docker/bin/docker_stats.sh" Cannot connect to the Docker daemon. Is the docke r daemon running on this host?
11-10-2015 17:14:28.006 +0000 ERROR ExecProcessor - message from "/opt/splunk/etc/apps/docker/bin/docker_top.sh" Cannot connect to the Docker daemon. Is the docker daemon running on this host?
```

That is your case. If you know how to fix permissions - do that. If you do not
know how to do that - the easiest fix for you to launch forwarder in this
container under `root` user


```bash
docker run --hostname docker \
    --name docker_stats_splunk_forwarder \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    -e "SPLUNK_FORWARD_SERVER=splunk_indexer:9997" \
    -e "SPLUNK_USER=root" \
    -d outcoldman/docker-stats-splunk-forwarder:latest
```
