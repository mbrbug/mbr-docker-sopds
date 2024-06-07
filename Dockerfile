FROM python:3.8.6-alpine
MAINTAINER am@ambr.cc

ENV DB_USER=sopds \
    DB_NAME=sopds \
    DB_PASS=sopds \
    DB_HOST="" \
    DB_PORT="" \
    EXT_DB=False \
    SOPDS_ROOT_LIB="/books" \
    SOPDS_INPX_ENABLE=True \
    SOPDS_LANGUAGE=ru-RU \
    MIGRATE=False \
    VERSION=0.43

# RUN apk --update add libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc openssl-dev openssl curl
# RUN apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev
# RUN apk add mariadb-dev
# ADD https://github.com/mitshel/sopds/archive/v0.48-devel.zip /sopds.zip
# RUN unzip sopds.zip && rm sopds.zip && mv sopds-* sopds
# ADD ./configs/settings.py /sopds/sopds/settings.py
RUN apk add git zsh mc curl openssh gcc musl-dev zlib-dev jpeg-dev freetype-dev openjpeg-dev tiff-dev vim mariadb-dev tzdata \
&& git clone -b master https://github.com/mbrbug/mbr-docker-sopds.git sopds
WORKDIR /sopds
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt \
&& pip3 install mysqlclient
# RUN pip3 install --upgrade pip && pip3 install -r requirements.txt && pip3 install mysqlclient
RUN rm -rf /sopds/convert/fb2conv && mkdir -p /sopds/convert/fb2conv && cd /sopds/convert/fb2conv \
&& wget https://github.com/rupor-github/fb2mobi/releases/download/3.6.67/fb2mobi_cli_linux_x86_64_glibc_2.23.tar.xz \
&& tar -xvf fb2mobi_cli_linux_x86_64_glibc_2.23.tar.xz && rm fb2mobi_cli_linux_x86_64_glibc_2.23.tar.xz \
&& curl -fsSL --retry 3 -o /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r4/sgerrand.rsa.pub \
&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r4/glibc-2.23-r4.apk \
&& apk add glibc-2.23-r4.apk \
&& cp /usr/lib/libexpat.so.1 /sopds/convert/fb2conv/libexpat.so.1 \
&& cp /lib/libz.so.1 /sopds/convert/fb2conv/libz.so.1 \
&& cp /lib/libc.musl-x86_64.so.1 /sopds/convert/fb2conv/libc.musl-x86_64.so.1
RUN apk del gcc openssh git
#RUN apk del mariadb-dev
ADD ./scripts/start.sh /start.sh
# ADD ./file/libmysqlclient.so /usr/lib/libmysqlclient.so
# ADD ./file/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
# ADD ./file/libmysqlclient.so.18.0.0 /usr/lib/libmysqlclient.so.18.0.0
# ADD ./file/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so
# ADD ./file/libmysqld.so /usr/lib/libmysqld.so
RUN chmod +x /start.sh

# VOLUME /usr/src/sopds/opds_catalog/log
# VOLUME /usr/src/sopds/opds_catalog/tmp
EXPOSE 8001

HEALTHCHECK --start-period=5s --interval=30s --retries=3 --timeout=5s \
CMD curl --fail http://localhost:8001 || sh -c 'kill -s 15 -1 && (sleep 10; kill -s 9 -1)'

ENTRYPOINT ["/start.sh"]
