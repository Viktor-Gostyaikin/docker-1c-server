FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV GOSU_VERSION 1.7

RUN apt-get -qq update \
  && apt-get clean

# RUN apt-get -qq install --yes --no-install-recommends ca-certificates wget locales \
#   && apt-get clean

RUN echo "#----- Install the dependencies -----" \
  && apt-get -qq install --yes --no-install-recommends fontconfig imagemagick \
  && apt-get clean \
  && fc-cache –fv

RUN echo "#----- Deal with ttf-mscorefonts-installer -----" \
  && apt-get -qq install --yes --no-install-recommends xfonts-utils cabextract \
  && apt-get -qq install --yes --no-install-recommends ttf-mscorefonts-installer \
  && apt-get clean

RUN echo "#----- Install gosu -----" \
  && wget --quiet --output-document /usr/local/bin/gosu \
  "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && apt-get clean

# buildkit
RUN apt-get install -y software-properties-common \
  && apt-get clean 

# buildkit
RUN apt -y full-upgrade \
  && apt install -y \
  ca-certificates \
  crudini \
  less \
  locales \
  openssh-client \
  # pulseaudio \
  # sudo \
  # supervisor \
  # uuid-runtime \
  # vim \
  # nano \
  # vlc \
  wget \
  # xauth \
  # xautolock \
  # xfce4 \
  # xfce4-clipman-plugin \
  # xfce4-cpugraph-plugin \
  # xfce4-netload-plugin \
  # xfce4-screenshooter \
  # xfce4-taskmanager \
  # xfce4-terminal \
  # xfce4-xkb-plugin \
  # xorgxrdp \
  # xprintidle \
  # xrdp \
  # && apt-get remove -yy xscreensaver \
  && apt-get autoremove -yy \
  && apt-get clean
  # && mkdir -p /var/lib/xrdp-pulseaudio-installer

RUN add-apt-repository "deb http://mirror.yandex.ru/ubuntu jammy main" -y

# Установка 1С
RUN apt-get update \
  && apt-get install -y \
  libenchant-2-dev \
  libharfbuzz-icu0 \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  libxslt1.1 \
  geoclue-2.0 \
  && apt-get clean

RUN apt-get install -y \
  libfreetype6 \
  libgsf-1-common \
  unixodbc \
  glib2.0 \
  && apt-get clean

RUN localedef --inputfile ru_RU --force --charmap UTF-8 --alias-file /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.utf8

# TODO загружать с файлового хранилища
COPY server64_8_3_23_1782.tar.gz /tmp/

RUN mkdir /tmp/server64_8_3_23_1782 \
  && tar -xzf /tmp/server64_8_3_23_1782.tar.gz -C /tmp/server64_8_3_23_1782 \
  && rm /tmp/server64_8_3_23_1782.tar.gz

RUN yes "" | /tmp/server64_8_3_23_1782/setup-full-8.3.23.1782-x86_64.run \
  && rm /tmp/server64_8_3_23_1782/setup-full-8.3.23.1782-x86_64.run

# Установка OScript

## Установка mono
RUN apt install -y mono-devel \
  && apt-get clean

COPY onescript-engine_1.8.4_all.deb /tmp/
RUN dpkg -i /tmp/onescript-engine_1.8.4_all.deb \
  && rm /tmp/onescript-engine_1.8.4_all.deb

## Установка gitsync
RUN opm i gitsync \
  && gitsync plugins init

### Установка плагинов
COPY gitsync/gitsync-plugins-itworks /root/.local/share/gitsync/plugins/gitsync-plugins-itworks
COPY gitsync/plugins.json /root/.local/share/gitsync/plugins/plugins.json


## Установка git
RUN apt-get -qq install --yes --no-install-recommends git \
  && apt-get clean

## Установка openssl
RUN apt-get -qq install --yes --no-install-recommends openssl \
  && apt-get clean

RUN apt-get -qq install --yes --no-install-recommends iputils-ping \
  && apt-get clean

RUN apt-get -qq install --yes --no-install-recommends xorg \
  && apt-get clean

RUN apt-get -qq install --yes --no-install-recommends xvfb \
  && apt-get clean

COPY container/docker-entrypoint.sh /repo/
ENTRYPOINT ["bash", "/repo/docker-entrypoint.sh"]

