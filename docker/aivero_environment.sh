export PREFIX=/opt/aivero/rgbd_toolkit_x86_64
export PATH=$PREFIX/bin:$PATH

export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$PREFIX/lib
#export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$PREFIX/lib

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export GST_PLUGIN_PATH=$PREFIX/lib/gstreamer-1.0:/usr/lib/x86_64-linux-gnu/gstreamer-1.0
# # this would be the gstreamer plugin-path for "normal" ubuntu, not docker:
# # export GST_PLUGIN_PATH=$PREFIX/lib/gstreamer-1.0:/lib/x86_64-linux-gnu/gstreamer-1.0
# export GST_PLUGIN_SCANNER=$PREFIX/bin/gst-plugin-scanner
# export PYTHONPATH=$PYTHONPATH:$PREFIX/lib
# export LIBVA_DRIVERS_PATH=$PREFIX/lib/dri