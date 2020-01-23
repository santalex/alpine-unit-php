FROM alpine:latest

RUN VER=1.14.0 \
    && CURL='curl' \
    && DEPS='binutils isl libatomic mpfr4 mpc1 gcc musl-dev libc-dev make pkgconf php7-dev php7-static openssl-dev' \
    && PHP='php7 php7-bcmath php7-bz2 php7-calendar php7-common php7-ctype php7-curl php7-dom php7-embed php7-enchant php7-exif php7-fileinfo php7-ftp php7-gd php7-gettext php7-iconv php7-intl php7-json php7-mbstring php7-mysqli php7-mysqlnd php7-opcache php7-openssl php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pear php7-pgsql php7-phar php7-session php7-shmop php7-simplexml php7-sockets php7-sodium php7-sqlite3 php7-tidy php7-xml php7-xmlreader php7-xmlrpc php7-xmlwriter php7-xsl php7-zip composer' \
    && apk add $DEPS $PHP $CURL \
    && cd /tmp \
    && wget https://unit.nginx.org/download/unit-$VER.tar.gz \
    && tar zxf unit-$VER.tar.gz \
    && cd /tmp/unit-$VER \
    && ./configure --prefix=/usr --openssl --state=/var/lib/unit --control=unix:/var/run/control.unit.sock --log=/var/log/unit.log --pid=/var/run/unit.pid \
    && make \
    && ./configure php --module=php \
    && make install \
    && apk del $DEPS \
    && cd /tmp \
    && rm -rf unit-$VER* \
    && mkdir -p /wwwroot

COPY docker-entrypoint.sh /usr/local/bin/
RUN mkdir /docker-entrypoint.d/
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

CMD ["unitd", "--no-daemon"]
