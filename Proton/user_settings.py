#To enable these settings, name this file "user_settings.py".
#Settings here will take effect for all games run in this Proton version.

user_settings = {
    #By default, logs are saved to $HOME/steam-<STEAM_GAME_ID>.log, overwriting any previous log with that name.
    #Log directory can be overridden with $PROTON_LOG_DIR.
  
    ###### Proton GE flags ######
    
    #Disable AMD FidelityFX Super Resolution (FSR), as it is enabled by default. FSR only works in vulkan games (dxvk and vkd3d-proton included).
    "WINE_FULLSCREEN_FSR": "0",

    #By default, the "balanced" resolution option for FSR is added to the resolution list if a mode is not specified.
    #possible modes : ultra, quality, balanced, performance.
#    "WINE_FULLSCREEN_FSR_MODE": "performance",

    #Add "widthxheight" to the in-game resolution list. Example resolution: 1234x4321
#    "WINE_FULLSCREEN_FSR_CUSTOM_MODE": "1920x1080"

    #The default sharpening of 5 is enough without needing modification, but can be changed with 0-5 if wanted.
    #0 is the maximum sharpness, higher values mean less sharpening.
    #2 is the AMD recommended default and is set by proton-ge.
#    "WINE_FULLSCREEN_FSR_STRENGTH": "2",

    ###### Proton flags ######
  
  #Spoof d3d12 feature level supported by vkd3d. Needed for some d3d12 games to work.
  "VKD3D_FEATURE_LEVEL": "12_2",
   
   #Enable Wayland display output. Games running with native Vulkan and OpenGL may have problems. Required for HDR support
   "PROTON_ENABLE_WAYLAND": "1",

   #Enable WoW64 Mode For Wine Prefixes
   "PROTON_USE_WOW64": "1",
  
    #Force Wine to enable the LARGE_ADDRESS_AWARE flag for all executables. Enabled by default.
    "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",

    #Enable automatic upgrading of AMD FidelityFX Super Resolution (FSR) to FSR4.
#   "PROTON_FSR4_UPGRADE": "1",

    #Enable HDR support. Requires Wayland to be enabled and for HDR to be enabled in system settings.
#   "PROTON_ENABLE_HDR":    "1",

    #Use OpenGL-based wined3d for d3d11, d3d10, and d3d9 instead of Vulkan-based DXVK
#    "PROTON_USE_WINED3D": "1",

    #Disable eventfd-based in-process synchronization primitives
#    "PROTON_NO_ESYNC": "1",

    #Disable futex-based in-process synchronization primitives
#    "PROTON_NO_FSYNC": "1",

    #Disable ntsync-based in-process synchronization primitives
#   "PROTON_NO_NTSYNC": "1",

    #Enable NVIDIA's NVAPI GPU support library.
#    "PROTON_ENABLE_NVAPI": "1",



    #Delay freeing some memory, to work around application use-after-free bugs.
#    "PROTON_HEAP_DELAY_FREE": "1",

    #Create an S: drive which points to the Steam Library which contains the game.
#    "PROTON_SET_GAME_DRIVE": "1",

    #Create an S: drive which points to the Steam Library which contains the game.
#    "PROTON_OLD_GL_STRING": "1",

    #Force Nvidia GPUs to always be reported as AMD GPUs.
    #Some games require this if they depend on Windows-only Nvidia driver functionality.
    #See also DXVK's nvapiHack config, which only affects reporting from Direct3D.
#    "PROTON_HIDE_NVIDIA_GPU": "1",

    #Disable support for memory write watches in ntdll.
    #This is a very dangerous hack and should only be applied if you have verified that the game can operate without write watches.
    #This improves performance for some very specific games (e.g. CoreRT-based games).
#    "PROTON_NO_WRITE_WATCH": "1",

    #When this envvar is set steam input and hidraw are disabled so that SDL takes priority over controller support.
#    "PROTON_PREFER_SDL": "1",

    ###### DXVK flags ######

    #DXVK debug logging; none|error|warn|info|debug
#    "DXVK_LOG_LEVEL": "info",

    #DXVK debug log; Set to none to disable log file creation entirely, without disabling logging.
#    "DXVK_LOG_PATH": "~/",

    #Enables use of the VK_EXT_debug_utils extension for translating performance event markers.
#    "DXVK_PERF_EVENTS": "1",

    #Enables use of the VK_EXT_debug_utils extension for translating performance event markers.
#    "DXVK_CONFIG_FILE": "~/.config/dxvk.conf",

    #Enable DXVK's HUD; devinfo|fps|frametimes|submissions|drawcalls|pipelines|memory|gpuload|version|api|compiler|samplers|scale=x
#    "DXVK_HUD": "devinfo,fps",

    #Limit the frame rate. A value of 0 uncaps the frame rate, while any positive value will limit rendering to the given number of frames per second.
#    "DXVK_FRAME_RATE": "60",

    #DXVK pipeline cache; "0" disable|"/some/directory" Defaults to the current working directory of the application.
#    "DXVK_STATE_CACHE": "0",

    #Selects devices with a matching Vulkan device name, which can be retrieved with tools such as vulkaninfo.
#    "DXVK_FILTER_DEVICE_NAME": "Device Name",

    #Vulkan debug layers. Requires the Vulkan SDK to be installed.
#    "VK_INSTANCE_LAYERS": "VK_LAYER_KHRONOS_validation",

    ###### Wine flags ######

    #Enable integer scaling mode, to give sharp pixels when upscaling.
#    "WINE_FULLSCREEN_INTEGER_SCALING": "1",

    #Wine debug logging
#    "WINEDEBUG": "+timestamp,+pid,+seh,+unwind,+debugstr,+loaddll,+mscoree",

    #vkd3d debug logging
#    "VKD3D_DEBUG": "warn",

    #wine-mono debug logging (Wine's .NET replacement)
#    "WINE_MONO_TRACE": "E:System.NotImplementedException",
#    "MONO_LOG_LEVEL": "info",

    #general purpose media logging
#    "GST_DEBUG": "4",
    #or, verbose converter logging (may impact playback performance):
#    "GST_DEBUG": "4,WINE:7,protonaudioconverter:7,protonaudioconverterbin:7,protonvideoconverter:7",
#    "GST_DEBUG_NO_COLOR": "1",

    #Write the command proton sends to wine for targeted prefix (/prefix/path/launch_command) - Helpful to track bound executable
    "PROTON_LOG_COMMAND_TO_PREFIX": "1",

    #Alternative way to run executables directly with wine binary instead of using steam.exe. This is the preffered way when using proton standalone.
#    "PROTON_STANDALONE_START": "1",

    #Disable nvapi and nvapi64
#     "PROTON_NVAPI_DISABLE": "1",

    #Pass "--use-gl=osmesa" to the command line. Fixes various launchers showing up with a black window (Star Citizen, Warframe, etc..). Might give poor perf on native opengl games, so disable in case of issues.
#    "PROTON_GL_OSMESA": "1",

    #Set a wine override to disable libglesv2. Fixes various launchers showing up with a black window (Star Citizen, Warframe, etc..). Alternative to running an app with `--use-gl=osmesa`, but more extreme.
    #Known to break at least the Rockstar Games Launcher, so only use if the PROTON_GL_OSMESA option above doesn't fix your issue.
    #We used to have a revert for that, but it would only affect upstream builds. This is a more universal solution - https://bugs.winehq.org/show_bug.cgi?id=44985
#    "PROTON_GLES2_DISABLE": "1",

    #Disable winedbg
     "PROTON_WINEDBG_DISABLE": "1",

    #Disable conhost
#     "PROTON_CONHOST_DISABLE": "1",

    #Disable IMAGE_FILE_LARGE_ADDRESS_AWARE override - In case it breaks your (32-bit) game - System Shock 2 is known to break with LAA enabled
#     "PROTON_DISABLE_LARGE_ADDRESS_AWARE": "1",

    #Reduce Pulse Latency
#     "PROTON_PULSE_LOWLATENCY": "1",

    #Enable Winetricks prompt on game launch
#     "PROTON_WINETRICKS": "1",

    #Enable seccomp-bpf filter to emulate native syscalls, required for some DRM protections to work. Requires staging on proton-tkg.
#    "PROTON_USE_SECCOMP": "1",



    #Use OpenGL-based wined3d for d3d11/10 only (keeping D9VK enabled). Comment out to use Vulkan-based DXVK instead.
#     "PROTON_USE_WINED3D11": "1",

    #Enable custom d3d9 dll usage. This is the option you want to enable to use Gallium 9. Builtin D9VK won't be used with this option enabled.
#    "PROTON_USE_CUSTOMD3D9": "1",

    #Use OpenGL-based wined3d for d3d9 only (keeping DXVK enabled). Comment out to use Vulkan-based D9VK or custom d3d9 dll instead.
#     "PROTON_USE_WINED3D9": "1",

    #Use Wine DXGI instead of DXVK's. This is needed to make use of VKD3D when DXVK is enabled. It will prevent the use of DXVK's DXGI functions.
#    "PROTON_USE_WINE_DXGI": "1",

    #Disable d3d9 entirely !!!
#    "PROTON_NO_D3D9": "1",

    #Disable futex2-based in-process synchronization primitives
#    "PROTON_NO_FUTEX2": "1",

    #Enforce driver shader cache path when Steam's shader pre-caching is disabled
#    "PROTON_BYPASS_SHADERCACHE_PATH": "",
}
