https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md#va_api
https://bbs.archlinux.org/viewtopic.php?id=244031&p=38
https://bbs.archlinux.org/viewtopic.php?id=244031&p=44
https://github.com/kvaster/gentoo-notes/blob/19889a937171a471891cf95bfde16a4fac2b4410/chromium.md?plain=1#L40

find / -name "*chromium*" 2> /dev/null

VA-API
This page documents tracing and debugging the Video Acceleration API (VaAPI or VA-API) on ChromeOS. VA-API is an open-source library and API specification, providing access to graphics hardware acceleration capabilities for video and image processing. VA-API is used on ChromeOS on both Intel and AMD platforms.

Contents
tracing
logging
Tracing power consumption
Verifying VaAPI installation and usage
Verify the VaAPI is correctly installed and can be loaded
Verify the VaAPI supports and/or uses a given codec
VaAPI on Linux
VaAPI on Linux with OpenGL
VaAPI on Linux with Vulkan
VA-API is implemented by a generic libva library, developed upstream on the VaAPI GitHub repository, from which ChromeOS is a downstream client via the libva package. Several backends are available for it, notably the legacy Intel i965, the modern Intel iHD and the AMD.



libva tracing
The environment variable LIBVA_TRACE=/path/to/file can be exposed to libva to store tracing information (see va_trace.c). libva will create a number of e.g. libva.log.033807.thd-0x00000b25 files (one per thread) with a list of the actions taken and semi-disassembled parameters.

libva logging
The environment variable LIBVA_MESSAGING_LEVEL=0 (or 1 or 2) can be used to configure increasing logging verbosity to stdout (see va.c). Chromium uses a level 0 by default in vaapi_wrapper.cc.

Tracing power consumption
Power consumption is available on ChromeOS test/dev images via the command line binary dump_intel_rapl_consumption; this tool averages the power consumption of the four SoC domains over a configurable period of time, usually a few seconds. These domains are, in the order presented by the tool:

pkg: estimated power consumption of the whole SoC; in particular, this is a superset of pp0 and pp1, including all accessory silicon, e.g. video processing.
pp0: CPU set.
pp1/gfx: Integrated GPU or GPUs.
dram: estimated power consumption of the DRAM, from the bus activity.
dump_intel_rapl_consumption results should be a subset and of the same numerical value as those produced with e.g. turbostat. Note that despite the name, the tool works on AMD platforms as well, since they provide the same type of measurement registers, albeit a subset of Intel's. Googlers can read more about this topic under go/power-consumption-meas-in-intel.

dump_intel_rapl_consumption is usually run while a given workload is active (e.g. a video playback) with an interval larger than a second to smooth out all kinds of system services that would show up in smaller periods, e.g. WiFi.

dump_intel_rapl_consumption --interval_ms=2000 --repeat --verbose
E.g. on a nocturne main1, the average power consumption while playing back the first minute of a 1080p VP9 video, the average consumptions in watts are:

pkg	pp0	pp1/gfx	dram
2.63	1.44	0.29	0.87
As can be seen, pkg ~= pp0 + pp1 + 1W, this extra watt is the cost of all the associated silicon, e.g. bridges, bus controllers, caches, and the media processing engine.

Verifying VaAPI installation and usage
 Verify the VaAPI is correctly installed and can be loaded
vainfo is a small command line utility used to enumerate the supported operation modes; it's developed in the libva-utils repository, but more concretely available on ChromeOS dev images (media-video/libva-utils package) and under Debian systems (vainfo). vainfo will try to load the appropriate backend driver for the system and/or GPUs and fail if it cannot find/load it.

 Verify the VaAPI supports and/or uses a given codec
A few steps are customary to verify the support and use of a given codec.

To verify that the build and platform supports video acceleration, launch Chromium and navigate to chrome://gpu, then:

Search for the “Video Acceleration Information” Section: this should enumerate the available accelerated codecs and resolutions.

If this section is empty, oftentimes the “Log Messages” Section immediately below might indicate an associated error, e.g.:

vaInitialize failed: unknown libva error

that can usually be reproduced with vainfo, see the previous section.

To verify that a given video is being played back using the accelerated video decoding backend:

Navigate to a url that causes a video to be played. Leave it playing.
Navigate to the chrome://media-internals tab.
Find the entry associated to the video-playing tab.
Scroll down to “Player Properties” and check the “video_decoder” entry: it should say “GpuVideoDecoder”.
VaAPI on Linux
VA-API on Linux is not supported, but it can be enabled using the flags below, and it might work on certain configurations -- but there's no guarantees.

To support proprietary codecs such as, e.g. H264/AVC1, add the options proprietary_codecs = true and ffmpeg_branding = "Chrome" to the GN args (please refer to the Setting up the build Section).
Build Chromium as usual.
At this point you should make sure the appropriate VA driver backend is working correctly; try running vainfo from the command line and verify no errors show up, see the previous section.

The following feature switch controls video encoding (see media switches for more details):

--enable-features=AcceleratedVideoEncoder
The following two arguments are optional:

--ignore-gpu-blocklist
--disable-gpu-driver-bug-workaround
The following feature can improve performance when using EGL/Wayland:

--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL
The NVIDIA VaAPI drivers are known to not support Chromium (see crbug.com/1492880). This feature switch is provided for developers to test VaAPI drivers on NVIDIA GPUs:

--enable-features=VaapiOnNvidiaGPUs, disabled by default
VaAPI on Linux with OpenGL
./out/gn/chrome --use-gl=angle --use-angle=gl \
--enable-features=AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,VaapiOnNvidiaGPUs \
--ignore-gpu-blocklist --disable-gpu-driver-bug-workaround
VaAPI on Linux with Vulkan
./out/gn/chrome --use-gl=angle --use-angle=vulkan \
--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE \
--ignore-gpu-blocklist --disable-gpu-driver-bug-workaround
Refer to the previous section to verify support and use of the VaAPI.

#################################################################################################

Full Vilkan support on native Wayland:
--ozone-platform=wayland --use-vulkan --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan

Optional hint for Vulkan:
--use-gl=angle --use-angle=vulkan
--enable-features=UseOzonePlatform

Optional Wayland hint:
--enable-features=WaylandWindowDecorations


VAAPI Decode (basic):
--enable-features=AcceleratedVideoDecodeLinuxGL

also zero copy variant:
--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL

VAAPI Decode (more options, not guarantee to work on new versions):
--enable-features=VaapiIgnoreDriverChecks,UseMultiPlaneFormatForHardwareVideo,PlatformHEVCDecoderSupport

VAAPI Encode:
--enable-features=AcceleratedVideoEncoder

also some other old options:
--enable-accelerated-mjpeg-decode --enable-global-vaapi-lock --use-gpu-scheduler-dfs --cast-streaming-hardware-h264


Other "performance" options
--enable-zero-copy --canvas-oop-rasterization --enable-gpu-rasterization
--enable-features=CanvasOopRasterization


Enabling Web GPU (only with unsafe option):
--enable-gpu --enable-unsafe-webgpu


Also a lot of workaround options like:
--disable-gpu-driver-bug-workarounds --ignore-gpu-blocklist
But they are for situations when "nothing helped"


!!! Do not try to enable Skia Graphite with Vulkan -- you will get neither Vulkan, nor Skia Graphite working !!!
!!! RawDraw with Vulkan "works" but you'll get content with all text disappeared !!!
