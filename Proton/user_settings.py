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

    #Alternative way to run executables directly with wine binary instead of using steam.exe. This is the preffered way when using proton standalone.
#   "PROTON_STANDALONE_START": "1",

    #Delay freeing some memory, to work around application use-after-free bugs.
#   "PROTON_HEAP_DELAY_FREE": "1",


    ###### Input Settings ######

    # Use SDL input instead of HIDRAW/Steam Input. When this envvar is set steam input and hidraw are disabled so that SDL takes priority over controller support.
#   "PROTON_PREFER_SDL": "1",
#   "PROTON_USE_SDL": "1",

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

    ###### NVIDIA NVAPI / DLSS ######

    # Enable nvapi support (for DLSS)
#   "PROTON_ENABLE_NVAPI": "1",

    # Disable nvapi and nvapi64
    "PROTON_NVAPI_DISABLE": "1",

    #Force Nvidia GPUs to always be reported as AMD GPUs. Some games require this if they depend on Windows-only Nvidia driver functionality.
    #See also DXVK's nvapiHack config, which only affects reporting from Direct3D.
#   "PROTON_HIDE_NVIDIA_GPU": "1",

    # Disable nvapi support in DXVK
    "DXVK_ENABLE_NVAPI": "0",


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


    ###### DXVK ######

    # Set DXVK config file path
#   "DXVK_CONFIG_FILE": "~/.config/dxvk.conf",

    # Limit the frame rate
#    "DXVK_FRAME_RATE": "120",

    # Enable DXVK's HUD; devinfo|fps|frametimes|submissions|drawcalls|pipelines|descriptors|memory|allocations|gpuload|version|api|cs|compiler|samplers|ffshaders|swvp|scale=x|opacity=y
    # DXVK_HUD=1 has the same effect as DXVK_HUD=devinfo,fps, and DXVK_HUD=full enables all available HUD elements
#   "DXVK_HUD": "fps,frametimes,api,compiler",

    # DXVK pipeline cache; "0" disable|"/some/directory" Defaults to the current working directory of the application
#   "DXVK_STATE_CACHE": "0",

    # Selects devices with a matching Vulkan device name, which can be retrieved with tools such as vulkaninfo
#   "DXVK_FILTER_DEVICE_NAME": "Device Name",


    ###### VKD3D-Proton ######

    #Spoof D3D12 feature level supported by VKD3D-Proton. Needed for some D3D12 games to work.
    "VKD3D_FEATURE_LEVEL": "12_2",

    # VKD3D disable DirectX Raytracing
    "VKD3D_CONFIG": "nodxr,force_host_cached",

    # VKD3D enable DirectX Raytracing
#   "VKD3D_CONFIG": "dxr,dxr12,force_host_cached",


    ###### Wine ######

    # Enable integer scaling mode
#   "WINE_FULLSCREEN_INTEGER_SCALING": "1",

}
