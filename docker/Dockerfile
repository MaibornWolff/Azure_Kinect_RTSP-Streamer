# This container only contains the rtsp-server and necessary settings.

FROM ubuntu:bionic as gstreamer
# Use this with nvidia gpu: You need to install nvidia-containers on host system (ubuntu 18.04/20.04) first
#FROM nvidia/opengl:base-ubuntu18.04 as dependencies

RUN apt-get update && \
apt-get install -y libgstreamer1.0-0 gstreamer1.0-plugins-base \
 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x \
 gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
 gstreamer1.0-rtsp  

FROM gstreamer as rtsp-server

RUN apt-get update && \
    apt-get install -y --fix-missing \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev wget git vim python3-pip libgstrtspserver-1.0-0 dos2unix \
    libgstreamer1.0-0 libgstrtspserver-1.0-0

RUN apt install xz-utils
COPY docker/rtsp-server/src src 
WORKDIR /src
RUN dos2unix /src/* && chmod +x install_rtsp.sh && bash +x install_rtsp.sh
RUN gcc -o stream  stream.c  `pkg-config --cflags --libs gstreamer-rtsp-server-1.0`

FROM rtsp-server as aivero-rgbd-toolkit

RUN apt-get update && \
  apt-get install --no-install-recommends -y python3-pip python3-setuptools python3-dev python3-venv python3-wheel git && \
  pip3 install --upgrade conan

RUN conan config install https://gitlab.com/aivero/public/conan/conan-config.git
RUN conan config set general.default_profile=linux_x86_64_release

WORKDIR /WORKDIR
ARG RGBD_TOOLKIT_VERSION=2.0.1
ENV CI_COMMIT_REF_SLUG=${RGBD_TOOLKIT_VERSION}
RUN git clone https://gitlab.com/aivero/public/aivero-rgbd-toolkit.git -b ${RGBD_TOOLKIT_VERSION}

WORKDIR /WORKDIR/aivero-rgbd-toolkit
RUN conan create . aivero/stable
RUN conan install aivero_rgbd_toolkit/${RGBD_TOOLKIT_VERSION}@aivero/stable -if /opt/aivero/rgbd_toolkit

FROM aivero-rgbd-toolkit as kinect-rtsp-streamer

WORKDIR /opt/aivero/rgbd_toolkit
# override the aivero_environment.sh with a custom version, containing the default gstreamer plugin-path
COPY docker/aivero_environment.sh .
RUN chmod +x ./aivero_environment.sh

WORKDIR /src
COPY docker/rtsp-server/rtsp-entry.sh .
RUN dos2unix ./rtsp-entry.sh

ENTRYPOINT ["bash", "+x", "rtsp-entry.sh"]