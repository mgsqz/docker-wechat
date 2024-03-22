FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=wechat
ENV GTK_IM_MODULE=fcitx
ENV QT_IM_MODULE=fcitx
ENV XMODIFIERS=@im=fcitx

COPY /packages/wechat-beta_1.0.0.145_amd64.deb /tmp/

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://open.weixin.qq.com/zh_CN/htmledition/res/assets/res-design-download/icon16_wx_logo.png && \
  echo "**** Lift login restrictions ****" && \
  curl -L -o /tmp/weixin_2.1.1_amd64.deb http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.1_amd64.deb && \
  dpkg -X /tmp/weixin_2.1.1_amd64.deb /tmp/out && \
  cp /tmp/out/usr/lib/libactivation.so /usr/lib/libactivation.so && \
  cp /tmp/out/etc/.kyact /etc/.kyact && \
  cp /tmp/out/etc/LICENSE /etc/LICENSE && \
  echo 'DISTRIB_ID=Kylin\nDISTRIB_RELEASE=V10\nDISTRIB_CODENAME=kylin\nDISTRIB_DESCRIPTION="Kylin V10 SP1"\nDISTRIB_KYLIN_RELEASE=V10\nDISTRIB_VERSION_TYPE=enterprise\nDISTRIB_VERSION_MODE=normal' > /etc/lsb-release && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    libqt5gui5 \
    thunar \
    tint2 && \
  apt-get install -y --no-install-recommends \
    libxrandr2 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-glx0 \
    libxcb-randr0 \
    libxcb-shm0 \
    libxcb-render0 \
    libxcb-image0 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    libxcb-sync1 \
    libxcb-render-util0 \
    libxcb-keysyms1 \
    libx11-xcb1 \
    libfontconfig1 \
    libatomic1 \
    libatk1.0-0 \
    libxcb-keysyms1 \
    libatk-bridge2.0-0 && \ 
  apt-get install -y \
    fonts-noto-cjk \
    im-config \
    zenity \
    fcitx \
    fcitx-googlepinyin \
    fcitx-config-gtk && \
  apt-get install -y --no-install-recommends \
    /tmp/wechat-beta_1.0.0.145_amd64.deb && \
  echo "**** openbox tweaks ****" && \
  sed -i \
    's/NLMC/NLIMC/g' \
    /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
