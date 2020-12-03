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

Usage examples can be found in docker/x11-entry.sh and docker/rtsp-server/x11-entry.sh