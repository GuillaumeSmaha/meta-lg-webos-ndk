# Config Layer to Build NDK For LG webOS TV

This layer overrides some configuration in webOS OSE, to generate a native SDK (unofficial) suitable for LG webOS TV.

Currently, this layer is tested to be applicable webOS OSE 1.0.g. It seems that webOS OSE 1.x is similar to LG webOS 4.x.
Which is running on many devices manufactured back in August 2018.

## What's changed in this layer?

Build configuration for webOS OSE was originally for `raspberrypi3`. Which is compiled with `hardfp` option.
LG's real devices are using armv7a (with arm64 kernel).
So changes were made to build an image with `softfp` option.

And some important system libraries are updated to reflect what's running in the real TV,
in order to maintain compatibility. More specifically:

* GStreamer was updated to 1.14.0, and included in NDK.
* SDL2 was updated to 2.0.5. Also, SDL2-image, SDL2-mixer and SDL2-ttf was included in NDK.
* `libwayland-egl.so.1`'s name was changed to `libwayland-egl.so.0`, to reflect lib version on TV.
* Qt Multimedia was included in NDK

By exploring more and more inside real TV, you may find there're something needs to be added.
Feel free to create an issue, or create a pull request.

## Build Instructions

### System Requirements

I built the NDK with a virtual machine running Ubuntu 16.04, which has 10 GB of RAM and 8 CPU cores. Minimum system requirement would be roughly

* 4 CPU cores
* 8 GB of RAM
* 200 GB of disk storage. 50 GB for fetched sources and more than 100 GB for build files.

On my computer (Ubuntu 16.04 in VirtualBox running on machine i9-9980HK, 32 GB DDR4-2666 and an entry level NVME SSD running Windows 10),
it took around 6 hours without any performance tweaks. The build failed somewhere when I tried to build with Ubuntu 18.04, or Debian 10.

After you got your build system ready, let's get started.

### Build Steps

To build the NDK, you'll need to follow instructions provided by webOS OSE:
[Building webOS Open Source Edition](https://www.webosose.org/docs/guides/setup/building-webos-ose/), with few more simple steps to add this layer.

1. After finishing the step [Cloning the Repository](https://www.webosose.org/docs/guides/setup/building-webos-ose/), add this layer to `weboslayers.py`:
```diff
 ('meta-webos-raspberrypi',    51, 'git://github.com/webosose/meta-webosose.git',            '', ''),
+('meta-lg-webos-ndk',         99, 'git@github.com:webosbrew/meta-lg-webos-ndk.git',         'branch=main', ''),
 ]
```

2. Continue build the system. If you can see Build Configuration below, then this layer is applied correctly.
```
Build Configuration:
BB_VERSION        = "1.32.0"
BUILD_SYS         = "x86_64-linux"
NATIVELSBSTRING   = "Ubuntu-16.04"
TARGET_SYS        = "arm-webos-linux-gnueabi"
MACHINE           = "raspberrypi3"
DISTRO            = "webos"
DISTRO_VERSION    = "1.0.g"
TUNE_FEATURES     = "arm armv7a vfp  neon" # <====================== NOTICE THIS
TARGET_FPU        = "softfp" # <==================================== NOTICE THIS
WEBOS_DISTRO_RELEASE_CODENAME = "webos-master"
WEBOS_DISTRO_BUILD_ID = "unofficial"
WEBOS_DISTRO_TOPDIR_REVISION = "1e7e06b48981fbe723beb48fe3db842ac2e642cf"
WEBOS_DISTRO_TOPDIR_DESCRIBE = "builds/master/1"
DATETIME          = "20201216130922"
meta-lg-webos-ndk = "main:ad3bcf879f12c1249e5126fc708963c05bc02d8d"
meta-webos-raspberrypi = "master:7c8e550398dd3ef7ab26f59023ede177f6f9830c"
meta-raspberrypi  = "morty:2a192261a914892019f4f428d7462bb3c585ebac"
meta-webos
meta-webos-backports-2.5
meta-webos-backports-2.4
meta-webos-backports-2.3 = "master:7c8e550398dd3ef7ab26f59023ede177f6f9830c"
meta-qt5          = "krogoth:f8584d7a7c90afc71484a40279aa3df651d0e04f"
meta-filesystems
meta-python
meta-networking
meta-multimedia
meta-oe           = "morty:b40116cf457b88a2db14b86fda9627fb34d56ae6"
meta              = "morty:1718f0a6c1de9c23660a9bebfd4420e3c4ed37e6"
```

3. After system image built, follow this instruction to build the NDK: 
[Native Development Kit Setup](https://www.webosose.org/docs/guides/setup/setting-up-native-development-kit/)

4. Now you can build some executables using this NDK! But Not for Qt programs. There's no tools such as `qmake` yet.
You will need to copy `sysroots/x86_64-linux` to somewhere else, `qmake` is inside this directory.
TODO: This section may be incorrect; Also there should be some better way to ship this part in the NDK installer.

5. To be completed...