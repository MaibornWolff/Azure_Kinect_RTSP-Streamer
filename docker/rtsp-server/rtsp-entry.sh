#!/bin/bash

source /opt/aivero/rgbd_toolkit_x86_64/aivero_environment.sh && \

# comment this in for debugging into the container - keeps it running
#tail -f /dev/null

# Test-video stream to see if server is working
# ./stream "( filesrc location=/rtsp-server/sample.mp4 ! qtdemux ! h264parse ! rtph264pay name=pay0 pt=96 )" "/kinect"
# ./stream "( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 )" "/kinect"

# RGB-Stream only
# ./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p framerate=15fps \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
# ! h264parse ! rtph264pay name=pay0 pt=96 )" "/kinect"

# colorizer stream x264enc (encoding on cpu)
# ./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
# framerate=15fps rectify-depth=true timestamp_mode=clock_all \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
# ! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
# ! h264parse ! rtph264pay name=pay0 pt=96 \
# demux.src_depth ! colorizer near-cut=2 far-cut=3 \
# ! videobox ! queue ! videoconvert \
# ! mix.)" "/kinect"

# far-cut works more as a "detail multiplier" for the custom libcolorizer.so (hsv-colors)
# bigger values mean less detail-> values between 2 - 8 may make sense

# Speed presets:
# None (0) – No preset
# ultrafast (1) – ultrafast
# superfast (2) – superfast
# veryfast (3) – veryfast
# faster (4) – faster
# fast (5) – fast
# medium (6) – medium
# slow (7) – slow
# slower (8) – slower
# veryslow (9) – veryslow
# placebo (10) – placebo 

# colorizer stream vaapih264enc (encoding on native cpu encoder)
./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
framerate=15fps rectify-depth=true timestamp_mode=clock_all \
! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
! vaapih264enc quality-level=4 ! video/x-h264, profile=baseline \
! h264parse ! rtph264pay name=pay0 pt=96 \
demux.src_depth ! colorizer near-cut=2 far-cut=3 \
! videobox ! queue ! videoconvert \
! mix.)" "/kinect"

# maybe a bit more speed
#vaapih264enc quality-level=7 cpb-length=1 default-roi-delta-qp=10

# Uses rtsp-simple-server instead of buildin
# gst-launch-1.0 \
# k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
# framerate=15fps rectify-depth=true timestamp_mode=clock_all \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
# ! vaapih264enc quality-level=4 ! video/x-h264, profile=baseline \
# ! rtspclientsink location=rtsp://rtsp-simple-server:8554/kinect \
# demux.src_depth ! colorizer near-cut=2 far-cut=3 \
# ! videobox ! queue ! videoconvert \
# ! mix.

# no colorizer (grey)
# ./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
# framerate=15fps rectify-depth=true timestamp_mode=clock_all \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
# ! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
# ! h264parse ! rtph264pay name=pay0 pt=96 \
# demux.src_depth \
# ! videobox ! queue ! videoconvert
# ! mix.)" "/kinect"


# There are lots of opzimization parameters for more speed. E.g:
#realtime: https://stackoverflow.com/questions/30730082/realtime-zero-latency-video-stream-what-codec-parameters-to-use