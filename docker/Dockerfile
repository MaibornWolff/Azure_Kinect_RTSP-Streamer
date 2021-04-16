FROM ubuntu:bionic as dependencies
# Use this with nvidia gpu: You need to install nvidia-containers on host system (ubuntu 18.04/20.04) first
#FROM nvidia/opengl:base-ubuntu18.04 as dependencies

RUN apt-get update && \
apt-get install -y libgstreamer1.0-0 gstreamer1.0-plugins-base \
 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x \
 gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
 gstreamer1.0-rtsp

FROM dependencies as rtsp-server

RUN apt-get update && \
    apt-get install -y --fix-missing \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev wget git vim python3-pip libgstrtspserver-1.0-0 \
    libgstreamer1.0-0 libgstrtspserver-1.0-0

RUN apt install xz-utils
COPY docker/rtsp-server/content rtsp-server
WORKDIR /rtsp-server

RUN chmod +x install_rtsp.sh && bash +x install_rtsp.sh && chmod +r gst-rtsp-server-1.4.0.tar.xz
RUN gcc -o stream  stream.c  `pkg-config --cflags --libs gstreamer-rtsp-server-1.0`

FROM rtsp-server as aivero-rgbd-toolkit

# This will install rgbd-toolkit from source

# RUN apt-get update && \
#   apt-get install --no-install-recommends -y python3-pip python3-setuptools python3-dev python3-venv python3-wheel git && \
#   pip3 install --upgrade conan

# WORKDIR /opt/aivero/repository
# RUN conan config install https://gitlab.com/aivero/public/conan/conan-config.git
# RUN conan config set general.default_profile=linux_x86_64_release
# ARG RGBD_TOOLKIT_VERSION=2.0.1
# ENV CI_COMMIT_REF_SLUG=${RGBD_TOOLKIT_VERSION}
# RUN git clone https://gitlab.com/aivero/public/aivero-rgbd-toolkit.git -b ${RGBD_TOOLKIT_VERSION}

# WORKDIR /opt/aivero/repository/aivero-rgbd-toolkit
# RUN conan create . aivero/stable
# RUN conan install aivero_rgbd_toolkit/${RGBD_TOOLKIT_VERSION}@aivero/stable -if /opt/aivero/rgbd_toolkit

RUN mkdir -p /opt/aivero
RUN chown $USER:$USER /opt/aivero

COPY docker/rgbd-toolkit /opt/aivero
WORKDIR /opt/aivero
RUN tar -C / -xvf aivero_rgbd_toolkit_2.0.0_x86_64.tar.bz2


FROM aivero-rgbd-toolkit as kinect-rtsp-streamer

WORKDIR /opt/aivero/rgbd_toolkit
COPY docker/aivero_environment.sh .
RUN chmod +x ./aivero_environment.sh

# # x11 stuff: needed for x11 Display-streaming to host (e.g. debugging if kinect works)
RUN groupadd -g 1000 lyonn
RUN useradd -d /home/lyonn -s /bin/bash -m lyonn -u 1000 -g 1000
USER lyonn
ENV HOME /home/lyonn
# alternative entrypoint for x11 stream to host
# COPY docker/x11-entry.sh .
# ENTRYPOINT ["bash", "+x", "x11-entry.sh"]
# ###############

WORKDIR /rtsp-server
COPY docker/rtsp-server/rtsp-entry.sh .
ENTRYPOINT ["bash", "+x", "rtsp-entry.sh"]
#CMD tail -f /dev/null
