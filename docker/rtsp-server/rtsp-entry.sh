#!/bin/bash

source /opt/aivero/rgbd_toolkit/aivero_environment.sh && \

# Test-video stream to see if server is working
#./stream "( filesrc location=/src/sample-mp4-file.mp4 ! qtdemux ! h264parse ! rtph264pay name=pay0 pt=96 )" "/test"

# RGB-Stream only
# ./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p framerate=15fps \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
# ! h264parse ! rtph264pay name=pay0 pt=96 )" "/kinect"

# colorizer stream
# ./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
# framerate=15fps rectify-depth=true timestamp_mode=clock_all \
# ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
# ! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
# ! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
# ! h264parse ! rtph264pay name=pay0 pt=96 \
# demux.src_depth ! colorizer near-cut=300 far-cut=5000 \
# ! videobox ! queue ! videoconvert
# ! mix.)" "/kinect"

# no colorizer (grey)
./stream "( k4asrc timestamp-mode=clock_all enable_color=true color-format=nv12 color-resolution=720p depth-mode=nfov_unbinned \
framerate=15fps rectify-depth=true timestamp_mode=clock_all \
! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert \
! videobox ! videomixer name=mix sink_0::xpos=0 sink_1::xpos=1280 \
! x264enc speed-preset=ultrafast tune=zerolatency ! video/x-h264, profile=baseline \
! h264parse ! rtph264pay name=pay0 pt=96 \
demux.src_depth \
! videobox ! queue ! videoconvert
! mix.)" "/kinect"


#you can test with encodebin for even more fast speed by native encodeing (currently not working):
#./stream "( k4asrc timestamp-mode=clock_all enable_color=true ! queue ! rgbddemux name=demux demux.src_color ! queue ! videoconvert ! encodebin )" "/test"
#realtime: https://stackoverflow.com/questions/30730082/realtime-zero-latency-video-stream-what-codec-parameters-to-use