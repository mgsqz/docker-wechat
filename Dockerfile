FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=wechat
ENV GTK_IM_MODULE=fcitx
ENV QT_IM_MODULE=fcitx
ENV XMODIFIERS=@im=fcitx

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/favicon.ico \
    https://open.weixin.qq.com/zh_CN/htmledition/res/assets/res-design-download/icon16_wx_logo.png && \
  echo "**** download packages ****" && \
  curl -o /tmp/WeChatLinux_x86_64.deb \
    https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libatomic1 \
    libxkbcommon-x11-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-render-util0-dev \
    libxcb-keysyms1-dev \
    zenity && \
  apt-get install -y --no-install-recommends \
    /tmp/WeChatLinux_x86_64.deb
RUN \
  echo "**** add fcitx5 ****" && \
  apt-get install -y --no-install-recommends \
    fcitx5 \
    fcitx5-chinese-addons && \
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
