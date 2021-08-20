ARG UbuntuVer=focal
FROM ubuntu:${UbuntuVer}

ARG UbuntuVer=focal
ARG DEBIAN_FRONTEND=noninteractive
ARG MonoURL=https://dl.winehq.org/wine/wine-mono/5.1.1/wine-mono-5.1.1-x86.tar.xz
ARG GeckoURL=https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.tar.xz
ARG noVNCURL=https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz
ARG websockify=https://github.com/novnc/websockify/archive/v0.10.0.tar.gz

ENV HOME /root
ENV LANG C.UTF-8
ENV TZ=Asia/Shanghai

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32

ENV DISPLAY :0

EXPOSE 8080

RUN dpkg --add-architecture i386 && \
    apt update && apt -y install vim wget tar net-tools monit gnupg2 xvfb x11vnc python3.8 && \
    wget -O- https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ '${UbuntuVer}' main' | tee /etc/apt/sources.list.d/wine.list && \
    apt update && apt -y install winehq-stable fluxbox && \
    apt -y full-upgrade && apt clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/wine/mono/ /usr/share/wine/gecko && \
    wget -O- ${MonoURL} | tar -xJ -C /usr/share/wine/mono/ && \
    wget -O /usr/share/wine/gecko/wine-gecko.msi ${GeckoURL} && \
    wget -O- ${noVNCURL} | tar -xz -C /root/ && mv /root/noVNC-* /root/novnc && \
    ln -s /root/novnc/vnc.html /root/novnc/index.html && \
    wget -O- ${websockify} | tar -xz -C /root/ && mv /root/websockify-* /root/novnc/utils/websockify && \
    sed -i 's#proxy_pid="$!"#proxy_pid="$!"\necho ${proxy_pid} > /var/run/websockify.pid #g' /root/novnc/utils/launch.sh && \
    ln -s /bin/python3.8 /bin/python3

ADD monit.conf /etc/monit/conf.d/monit.conf
ADD mservice.sh /root/mservice.sh

WORKDIR /root/

CMD ["/bin/bash","-c","set -e && /bin/monit","-I"]
