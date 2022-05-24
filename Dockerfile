FROM python:3.8.6-alpine
MAINTAINER am@homembr.ru

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
RUN apk add git openssh gcc musl-dev zlib-dev jpeg-dev freetype-dev openjpeg-dev tiff-dev vim mariadb-dev tzdata \
&& git clone https://github.com/PeterVoronov/sopds.git
WORKDIR /sopds
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt \
&& pip3 install mysqlclient
# RUN pip3 install --upgrade pip && pip3 install -r requirements.txt && pip3 install mysqlclient
RUN apk del gcc openssh git
#RUN apk del mariadb-dev
ADD ./scripts/start.sh /start.sh
# ADD ./file/libmysqlclient.so /usr/lib/libmysqlclient.so
# ADD ./file/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
# ADD ./file/libmysqlclient.so.18.0.0 /usr/lib/libmysqlclient.so.18.0.0
# ADD ./file/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so
# ADD ./file/libmysqld.so /usr/lib/libmysqld.so
RUN chmod +x /start.sh

VOLUME /usr/src/sopds/opds_catalog/log
VOLUME /usr/src/sopds/opds_catalog/tmp
EXPOSE 8001

ENTRYPOINT ["/start.sh"]