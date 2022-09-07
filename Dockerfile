FROM ubuntu:jammy

# ENV variables
ENV DEBIAN_FRONTEND noninteractive
ENV TZ "America/New_York"
ENV CUPSADMIN admin
ENV CUPSPASSWORD password

LABEL maintainer="Anuj Datar <anuj.datar@gmail.com>"
LABEL version="1.0"
LABEL name="anujdatar/cups"
LABEL description="CUPS docker image"
LABEL repository="https://github.com/anujdatar/cups-docker"


# Install dependencies
RUN apt-get update -qq  && apt-get upgrade -qqy && \
    apt-get install -qqy apt-utils usbutils \
    cups git build-essential cmake libcups2-dev libcupsimage2-dev tzdata


RUN git clone https://github.com/klirichek/zj-58 /zj58
RUN cd /zj58 && mkdir build && cd build && cmake ../
RUN cmake --build /zj58/build
RUN mkdir /usr/share/cups/model/zjiang && cp /zj58/build/ppd/zj80.ppd /usr/share/cups/model/zjiang/zj80.ppd
RUN cp /zj58/build/rastertozj /usr/lib/cups/filter/rastertozj

EXPOSE 631

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
    echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
