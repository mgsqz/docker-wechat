FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=wechat
ENV GTK_IM_MODULE=fcitx
ENV QT_IM_MODULE=fcitx
ENV XMODIFIERS=@im=fcitx

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://open.weixin.qq.com/zh_CN/htmledition/res/assets/res-design-download/icon16_wx_logo.png && \
  echo "**** download packages ****" && \
  curl -o /tmp/WeChatLinux_x86_64.deb \
    https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    libqt5gui5 \
    thunar \
    tint2 && \
  apt-get install -y --no-install-recommends \
    libatomic1 \
    libxkbcommon-x11-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-render-util0-dev \
    libxcb-keysyms1-dev && \
  apt-get install -y --no-install-recommends \
    /tmp/WeChatLinux_x86_64.deb
RUN \
  apt-get install -y \
    fonts-noto-cjk \
    im-config \
    zenity \
    fcitx5 \
    fcitx5-chinese-addons && \
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
