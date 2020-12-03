wget https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.4.0.tar.xz
tar -xf gst-rtsp-server-1.4.0.tar.xz
cd gst-rtsp-server-1.4.0
./configure 
make
make check
make install
make installcheck