FROM mongo:3.2.6
MAINTAINER Antoine Carton <carton.antoine@gmail.com>

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /backup

ENTRYPOINT ["/entrypoint.sh"]
