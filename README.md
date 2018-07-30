https://github.com/mbrbug/mbr-docker-sopds.git

# Introduction

Dockerfile to build a Simple OPDS server docker image.
http://www.sopds.ru

# Installation

git clone https://github.com/mbrbug/mbr-docker-sopds.git

# Quick Start

Run the image

```
docker run --name sopds --rm -d \
   --volume /path/to/library:/library:ro \
   --publish 8081:8001 \
   zveronline/sopds
```

This will start the sopds server and you should now be able to browse the content on port 8081.

Also you can store database on external storage

```
docker run --name sopds -d \
   --volume /path/to/library:/library:ro \
   --volume /path/to/database:/var/lib/pgsql \
   --publish 8081:8001 \
   zveronline/sopds
```

# Create superuser

```bash
docker exec -ti sopds bash
python3 manage.py createsuperuser
```

# Scan library

```bash
docker exec -ti sopds bash
python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY True
```
