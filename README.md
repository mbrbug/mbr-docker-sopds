https://github.com/mbrbug/mbr-docker-sopds.git

# Introduction

Dockerfile to build a Simple OPDS server docker image.
http://www.sopds.ru

# Installation

build the image yourself.

```
docker build -t mbr/sopds .
```

# Quick Start

Run the image

```
docker run --name sopds -d \
   --volume /path/to/library:/books:ro \
   --publish 8081:8001 \
   mbr/sopds:latest
```

This will start the sopds server and you should now be able to browse the content on port 8081.
