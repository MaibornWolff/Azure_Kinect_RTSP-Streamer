FROM ubuntu:bionic as kinect-rtsp-streamer

RUN apt-get update && \
apt-get install software-properties-common -y

RUN add-apt-repository ppa:jonathonf/ffmpeg-4 -y && \
apt-get update && \
apt-get install -y ffmpeg

COPY docker/rtsp-server/content rtsp-server

#CMD tail -f /dev/null
CMD ffmpeg -re -stream_loop -1 -i /rtsp-server/sample.mp4 -c copy -f rtsp rtsp://rtsp-simple-server:8554/kinect