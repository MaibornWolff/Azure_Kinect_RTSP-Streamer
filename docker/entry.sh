#!/bin/bash

#source ./aivero_environment.sh && tail -f /dev/null
#k4aviewer
source /opt/aivero/rgbd_toolkit_x86_64/aivero_environment.sh && \
# Color rtsp sender
# gst-launch-1.0 k4asrc enable_color=true \
# ! queue ! rgbddemux name=demux demux.src_color ! queue \
# ! videoconvert ! x264enc \
# ! rtspclientsink location=rtsp://rtsp-simple-server:8554/color

# Depth rtsp sender
# gst-launch-1.0 k4asrc enable_color=true \
# ! queue ! rgbddemux name=demux demux.src_depth \
# ! colorizer near-cut=300 far-cut=5000 ! queue \
# ! videoconvert ! x264enc \
# ! rtspclientsink location=rtsp://rtsp-simple-server:8554/color

#for rts stream
# gst-launch-1.0 k4asrc enable_color=true \
# ! queue ! rgbddemux name=demux demux.src_depth \
# ! colorizer near-cut=300 far-cut=5000 \
# ! queue ! videoconvert ! queue \
# ! autovideosink demux.src_color ! queue \
# ! videoconvert ! x264enc \
# ! rtspclientsink location=rtsp://rtsp-simple-server:8554/color

#Test rtsp sender
#gst-launch-1.0 videotestsrc ! x264enc ! rtspclientsink location=rtsp://rtsp-server:8554/realtest

# Receive rtsp:
#gst-launch-1.0 rtspsrc latency=0 location=rtsp://localhost:8554/test ! rtph264depay ! decodebin ! autovideosink

#! udpsink host=rtsp-simple-server port=8000

# for video via x11 on host
gst-launch-1.0 k4asrc enable_color=true rectify-depth=true timestamp_mode=clock_all real-time-playback=true \
depth-mode=nfov_unbinned framerate=15fps \
! queue ! rgbddemux name=demux demux.src_depth \
! queue ! videoconvert ! queue \
! autovideosink demux.src_color ! queue \
! videoconvert ! autovideosink

# for video via x11 on host h264 encoded
# gst-launch-1.0 k4asrc enable_color=true rectify-depth=true timestamp_mode=clock_all real-time-playback=true \
# depth-mode=nfov_unbinned framerate=15fps \
# ! queue ! rgbddemux name=demux demux.src_color ! queue \
# ! videoconvert !  \
# x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline ! decodebin ! autovideosink
# ! h264parse ! rtph264pay ! autovideosink


# #mix x11
# gst-launch-1.0 \
#    k4asrc enable_color=true rectify-depth=true timestamp_mode=clock_all real-time-playback=true color-format=nv12 color-resolution=720p \
#    depth-mode=nfov_unbinned framerate=15fps \
#    ! queue ! rgbddemux name=demux demux.src_color ! queue ! \
#    videoconvert ! \
#    videobox top=0 bottom=0 right=-700 ! \
#    videomixer name=mix sink_0::xpos=0 sink_0::sync=false sink_1::xpos=1300 sink_1::sync=false ! \
#    videoconvert ! xvimagesink demux.src_depth ! \
#    colorizer near-cut=300 far-cut=5000 ! \
#    videobox border-alpha=1 ! \
#    queue ! videoconvert ! mix.


# mix rtsp;
# gst-launch-1.0 \
#    k4asrc enable_color=true rectify-depth=true timestamp_mode=clock_all real-time-playback=true color-format=nv12 color-resolution=720p \
#    depth-mode=nfov_unbinned framerate=15fps \
#    ! queue ! rgbddemux name=demux demux.src_color ! queue ! \
#    videoconvert ! \
#    videobox top=0 bottom=0 right=-700 ! \
#    videomixer name=mix sink_0::xpos=0 sink_1::xpos=1300 ! \
#    videoconvert ! x264enc ! \
#    rtspclientsink location=rtsp://rtsp-simple-server:8554/color demux.src_depth ! \
#    colorizer near-cut=300 far-cut=5000 ! \
#    videobox border-alpha=1 ! \
#    queue ! videoconvert ! mix.

# keeps container alive when doing nothing
#tail -f /dev/null

#SaveToFile:
#https://stackoverflow.com/questions/25840509/how-to-save-a-rtsp-video-stream-to-mp4-file-via-gstreamer