# Azure Kinect RTSP-Streamer

This Repository contains a dockerized RTSP-Streamer / Server for streaming the Kinects RGB- and Depth-Stream to network
by merging them into one Video. Our goal with this is to be independent from the actual (Kinect + Computational) Hardware
and easily use the RTSP-Stream on all kinds of clients in the local network, e.g. Microsoft Hololens.

The docker-container mainly contains a **GStreamer-Pipeline** for creating and merging the Video-Stream. The Pipeline is based
on the **Aivero RGBD Toolkit** which provides plugins for using the kinect as video-source and demuxing the color + depth streams.

https://gstreamer.freedesktop.org/
https://gitlab.com/aivero/public/aivero-rgbd-toolkit


## Usage

Execute the "startup.sh" if you want to use x11-server for seeing docker UI on the host system (Ubuntu 18.04/20.04 tested).
Otherwise docker-compose up --build is sufficient, as DISPLAY and HOSTNAME are not needed.

Clone with submodules:
- git submodule update --init --recursive

before docker-compose up:
    export HOSTNAME

Setup kinect on ubuntu host (first time):
- to run k4aviewer (and kinect) without sudo, execute /aivero/rgbd_toolkit_scripts/setup_udev_rules_k4a.sh

Install nvidia driver on host (only necessary for pc with nvidia graphics):
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-driver-440
-> Use ubuntu:bionic as base for non nvidia pcs


NVIDIA Container runtime on host (needed to have gpu access and nvidia drivers there):
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update
sudo apt-get install nvidia-container-runtime
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime":"nvidia"
}
EOF
sudo pkill -SIGHUP dockerd

docker info|grep -i runtime
 Runtimes: nvidia runc
 Default Runtime: runc
 -> default runtime in daemon.json may be optional

Test it:
sudo systemctl stop docker
sudo systemctl start docker
docker run --gpus all nvidia/cuda:10.2-cudnn7-devel nvidia-smi
nvidia-smi command should run on all containers if it works


After all setup is done, x11-stream should be sent to host

camera modes:
https://gitlab.com/aivero/public/gstreamer/gst-k4a/-/blob/master/src/enums.rs



aivero_environment.sh can be changed to include also "normal" gstreamer plugins:
  export GST_PLUGIN_PATH=$PREFIX/lib/gstreamer-1.0:/lib/x86_64-linux-gnu/gstreamer-1.0
