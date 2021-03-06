FROM ubuntu
USER root

RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/michael067/rtorrent-rutorrent-shared.git a && \
    cp ./a/extra.list /etc/apt/sources.list.d/extra.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y vim net-tools rtorrent unzip zip unrar rar tar bzip2 plowshare mediainfo curl php-fpm php-cli php-geoip php-mbstring php-zip nginx wget ffmpeg supervisor php-xml libarchive-zip-perl libjson-perl libxml-libxml-perl irssi sox python3 python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    pip3 install cloudscraper && \ 
    rm -rf /var/lib/apt/lists/* && \
    cp ./a/rutorrent-*.nginx /root/ && \
    mkdir -p /var/www && cd /var/www && \
    git clone https://github.com/Novik/ruTorrent.git rutorrent && \
    cd /var/www/rutorrent/plugins && \
    git clone https://github.com/michael067/rutorrent-thirdparty-plugins.git filemgnt && \
    mv filemgnt/* . && rm -rf filemgnt && \
    ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/rutorrent/share.php && \
    rm -rf ./rutorrent/.git* && cd / && \
    cp ./a/config.php /var/www/rutorrent/conf/ && \
    cp ./a/startup-rtorrent.sh ./a/startup-nginx.sh ./a/startup-php.sh ./a/startup-irssi.sh ./a/.rtorrent.rc /root/ && \
    cp ./a/supervisord.conf /etc/supervisor/conf.d/ && \
    mkdir -p /home/rtorrent/.config/plowshare/modules.d && \
    cd /home/rtorrent/.config/plowshare/modules.d && \
    curl -L -k https://github.com/mcrapet/plowshare-modules-legacy/archive/master.tar.gz | tar zxf - && \
    mv plowshare-modules-legacy-master legacy && \
    sed -i 's/\/var\/log/\/downloads\/\.log/g' /etc/nginx/nginx.conf && \
    sed -i 's/vps.mydomain.com/vps.mydomain.ml\/rutorrent/g' /var/www/rutorrent/plugins/fileshare/conf.php

EXPOSE 80 443 49160 49161 5000
VOLUME /downloads

CMD ["supervisord"]
