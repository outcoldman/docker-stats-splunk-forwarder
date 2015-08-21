# Table of Contents

- [Supported tags](#supported-tags)
- [Introduction](#introduction)
    - [Version](#version)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)

## Supported tags

- `latest`

## Introduction

Dockerfile to build Splunk Universal Forwarder with preconfigured scripts
which monitors Docker host. It uses official docker client to read `inspect`
and `top`. Mounting `/var/run/docker.sock` from the host is required.

## Version

- Docker version: `1.8.1`
- Splunk Universal Forwarder: `6.2.5`

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
    --name docker_stats_splunk_forwarder
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    -d outcoldman/docker-stats-splunk-forwarder:latest
```

After that you can specify splunk indexer

```
docker exec -it docker_stats_splunk_forwarder entrypoint.sh splunk add forward-server splunk_indexer:9997
```

## Configuration

See [docker-splunk](https://github.com/outcoldman/docker-splunk) for more details.
