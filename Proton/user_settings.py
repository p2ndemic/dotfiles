# To enable these settings, name this file "user_settings.py".
# Settings here will take effect for all games run in this Proton version.

user_settings = {
    #By default, logs are saved to $HOME/steam-<STEAM_GAME_ID>.log, overwriting any previous log with that name.
    #Log directory can be overridden with $PROTON_LOG_DIR.
    
    ###### Logging ######

    # Enable logging
    "PROTON_LOG": "0",

    #Log directory can be overridden with $PROTON_LOG_DIR.
#   "PROTON_LOG_DIR": "~/",

    #When running a game, Proton will write some useful debug scripts for that game into $PROTON_DEBUG_DIR/proton_$USER/.
#   "PROTON_DUMP_DEBUG_COMMANDS": "1",

    #Root directory for the Proton debug scripts, /tmp by default.
#   "PROTON_DEBUG_DIR": "1",

    # Write the command Proton sends to Wine for targeted prefix (/prefix/path/launch_command)
    # Helpful to track bound executable
#   "PROTON_LOG_COMMAND_TO_PREFIX": "1",


    ###### Graphics / API ######

    #Disable DiretX12 [d3d12.dll], for d3d12 games which can fall back to and run better with d3d11.
#   "PROTON_NO_D3D12": "1",

    #Disable DiretX11 [d3d11.dll], for d3d11 games which can fall back to and run better with d3d10.
#   "PROTON_NO_D3D11": "1",

    #Disable DiretX10 [d3d10.dll] and [dxgi.dll], for d3d10 games which can fall back to and run better with d3d9.
#   "PROTON_NO_D3D10": "1",

    # Use OpenGL-based wined3d for d3d11, d3d10, and d3d9 instead of Vulkan-based DXVK
#   "PROTON_USE_WINED3D": "1",

    #Use Wine DXGI instead of DXVK's. This is needed to make use of VKD3D when DXVK is enabled. It will prevent the use of DXVK's DXGI functions.
#   "PROTON_USE_WINE_DXGI": "1",


    ###### Debug / Performance Tweaks ######
    
    # Force Wine to enable the LARGE_ADDRESS_AWARE flag for all executables
    "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",

    # Disable winedbg
    "PROTON_WINEDBG_DISABLE": "1",

    # Disable conhost
    "PROTON_CONHOST_DISABLE": "1",

    # Enable WoW64 Mode For Wine Prefixes
    "PROTON_USE_WOW64": "1",

    #Enable Wayland display output. Currently under active development. May cause input lag in some games (e.g., Unity engine). Required for HDR.
#   "PROTON_ENABLE_WAYLAND": "1",

    #Enable HDR support. Requires Wayland to be enabled and for HDR to be enabled in system settings.
#   "PROTON_ENABLE_HDR": "1",

    # Enable Winetricks prompt on game launch
#   "PROTON_WINETRICKS": "1",

    #Alternative way to run executables directly with wine binary instead of using steam.exe. This is the preffered way when using proton standalone.
#   "PROTON_STANDALONE_START": "1",

    #Delay freeing some memory, to work around application use-after-free bugs.
#   "PROTON_HEAP_DELAY_FREE": "1",

    #Disable support for memory write watches in ntdll. This is a very dangerous hack and should only be applied if you have verified that the game can operate without write watches.
    #This improves performance for some very specific games (e.g. CoreRT-based games).
#   "PROTON_NO_WRITE_WATCH": "1",

    
    ###### INTEL XeSS ######

    # → Added downloader for XeSS dlls (version 2.1.0), similar to the DLSS downloader
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250807-slr
#   "PROTON_XESS_UPGRADE": "1",


    ###### AMD FSR ######

    #Disable/Enable AMD FidelityFX Super Resolution (FSR), as it is enabled by default. FSR only works in vulkan games (dxvk and vkd3d-proton included).
#   "WINE_FULLSCREEN_FSR": "0",

    # Set FSR mode: ultra, quality, balanced, performance
#   "WINE_FULLSCREEN_FSR_MODE": "performance",

    # Custom resolution for FSR
#   "WINE_FULLSCREEN_FSR_CUSTOM_MODE": "1920x1080",

    # FSR sharpening (0–5, lower is sharper). #2 is the AMD recommended default and is set by proton-ge.
#   "WINE_FULLSCREEN_FSR_STRENGTH": "2",

    # Enable automatic upgrading of AMD FidelityFX Super Resolution (FSR) to FSR4.
#   "PROTON_FSR4_UPGRADE": "1",

    # Added PROTON_FSR4_RDNA3_UPGRADE for RDNA3 GPUs. Does the same thing as 'PROTON_FSR4_UPGRADE' but also sets some other necessary variables.
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250807-slr
#   "PROTON_FSR4_RDNA3_UPGRADE": "1",


    ###### NVIDIA NVAPI / DLSS ######

    # Enable nvapi support (for DLSS)
#   "PROTON_ENABLE_NVAPI": "1",

    # Disable nvapi and nvapi64
    "PROTON_NVAPI_DISABLE": "1",

    # Force Nvidia GPUs to always be reported as AMD GPUs. Some games require this if they depend on Windows-only Nvidia driver functionality.
    # See also DXVK's nvapiHack config, which only affects reporting from Direct3D.
#   "PROTON_HIDE_NVIDIA_GPU": "1",

    # Added downloader for DLSS dlls (version 310.3.0), similar to the FSR4 downloader. Use 'PROTON_DLSS_UPGRADE=1' environment variable to enable it.
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250714-slr
#   "PROTON_DLSS_UPGRADE": "1",

    # Added PROTON_DLSS_INDICATOR=1 environment variable to enable DLSS hud.
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250714-slr
#   "PROTON_DLSS_INDICATOR": "1",


    ###### Sync Primitives ######

    # Enable NTsync
    "PROTON_USE_NTSYNC": "1",

    # Disable eventfd-based in-process synchronization primitives
    "PROTON_NO_ESYNC": "1",

    # Disable futex-based in-process synchronization primitives
    "PROTON_NO_FSYNC": "1",

    # Disable support for fast (one syscall per NT syscall) synchronization primitives using the winesync driver in the kernel
#   "PROTON_NO_NTSYNC": "1",


    ###### Shader Cache ######

    # Enforce driver shader cache path when Steam's shader pre-caching is disabled
#   "PROTON_BYPASS_SHADERCACHE_PATH": "",

    # Added per-game shader cache, enabled by default, can be disabled with PROTON_LOCAL_SHADER_CACHE=0. Shaders will be cached under <steamlibrary>/shadercache/<appid> for each game, similarly to when shader pre-caching is enabled. You will get stuttering as the shader cache for each game is rebuilt but the cached shaders won't be evicted due to limited cache size.
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250807-slr
#   "PROTON_LOCAL_SHADER_CACHE": "0",


    ###### Input Settings ######

    # Use SDL input instead of HIDRAW/Steam Input. When this envvar is set steam input and hidraw are disabled so that SDL takes priority over controller support.
#   "PROTON_PREFER_SDL": "1",
#   "PROTON_USE_SDL": "1",


    ###### Other ######

    # Added PROTON_ENABLE_MEDIACONV env variable to enable proton mediaconverter. Mostly for testing purposes.
    # Ref: https://github.com/CachyOS/proton-cachyos/releases/tag/cachyos-10.0-20250702-slr
#   "PROTON_ENABLE_MEDIACONV": "0",


    ###### DXVK ######
    
    # Set DXVK config file path
#   "DXVK_CONFIG_FILE": "~/.config/dxvk.conf",

    # Limit the frame rate
#   "DXVK_FRAME_RATE": "60",

    # Enable DXVK's HUD; devinfo|fps|frametimes|submissions|drawcalls|pipelines|descriptors|memory|allocations|gpuload|version|api|cs|compiler|samplers|ffshaders|swvp|scale=x|opacity=y
    # DXVK_HUD=1 has the same effect as DXVK_HUD=devinfo,fps, and DXVK_HUD=full enables all available HUD elements
#   "DXVK_HUD": "devinfo,fps",

    # DXVK pipeline cache; "0" disable|"/some/directory" Defaults to the current working directory of the application
#   "DXVK_STATE_CACHE": "0",

    # Selects devices with a matching Vulkan device name, which can be retrieved with tools such as vulkaninfo
#   "DXVK_FILTER_DEVICE_NAME": "Device Name",

    # DXVK debug logging; none|error|warn|info|debug
#   "DXVK_LOG_LEVEL": "info",

    # DXVK debug log; Set to none to disable log file creation entirely, without disabling logging
#   "DXVK_LOG_PATH": "~/",

    # Enables use of the VK_EXT_debug_utils extension for translating performance event markers
#   "DXVK_PERF_EVENTS": "1",

    # Vulkan debug layers. Requires the Vulkan SDK to be installed
#   "VK_INSTANCE_LAYERS": "VK_LAYER_KHRONOS_validation",


    ###### VKD3D-Proton ######
    
    #Spoof D3D12 feature level supported by VKD3D-Proton. Needed for some D3D12 games to work.
    "VKD3D_FEATURE_LEVEL": "12_2",

    # VKD3D disable DirectX Raytracing
    "VKD3D_CONFIG": "nodxr,force_host_cached",
    
    # VKD3D enable DirectX Raytracing
#   "VKD3D_CONFIG": "dxr,dxr12,force_host_cached",

    #vkd3d debug logging
#   "VKD3D_DEBUG": "warn",

    #vkd3d-shader debug logging
#   "VKD3D_SHADER_DEBUG": "fixme",


    ###### Wine ######

    # Enable integer scaling mode
#   "WINE_FULLSCREEN_INTEGER_SCALING": "1",

    # Wine debug logging
#   "WINEDEBUG": "+timestamp,+pid,+seh,+unwind,+debugstr,+loaddll,+mscoree",

    # Wine-mono debug logging
#   "WINE_MONO_TRACE": "E:System.NotImplementedException",
#   "MONO_LOG_LEVEL": "info",

    # General purpose media logging
#   "GST_DEBUG": "4",

    # or Verbose converter logging (may impact performance)
#   "GST_DEBUG": "4,WINE:7,protonaudioconverter:7,protonaudioconverterbin:7,protonvideoconverter:7",
#   "GST_DEBUG_NO_COLOR": "1",
}
