FROM python:3.6-alpine3.7
#FROM python:3.6-alpine
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
    VERSION=0.46

#ADD ./sopds-zip/sopds.zip /sopds.zip
ADD ./scripts/start.sh /start.sh

RUN chmod +x /start.sh && apk add --update --no-cache tzdata libxml2-dev libxslt-dev libffi-dev musl-dev curl jpeg-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev \
	&& apk add --no-cache --virtual .build-deps mariadb-dev gcc \
	&& wget -O /sopds.zip https://github.com/mitshel/sopds/archive/master.zip \
	&& cd / && unzip sopds.zip && mkdir /sopds && cp -R /sopds-master/* /sopds && rm sopds.zip \
	&& cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && echo "Europe/Moscow" > /etc/timezone \
	&& sed -i 's/Django>=1.10/Django==1.11/' /sopds-master/requirements.txt && cd /sopds-master &&  pip3 install -r requirements.txt && pip3 install mysqlclient \
	&& apk del .build-deps \
	&& apk del tzdata \
	&& apk add --no-cache --virtual .runtime-deps mariadb-client-libs

WORKDIR /sopds

ADD ./configs/settings.py /sopds-master/sopds/settings.py

EXPOSE 8001

ENTRYPOINT ["/start.sh"]
