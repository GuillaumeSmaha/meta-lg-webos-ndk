FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_append = " \
    file://libsdl2-ttf-disable-opengl.patch \
"