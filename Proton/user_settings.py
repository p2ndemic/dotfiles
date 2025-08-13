# To enable these settings, name this file "user_settings.py".
# Settings here will take effect for all games run in this Proton version.

user_settings = {
    #By default, logs are saved to $HOME/steam-<STEAM_GAME_ID>.log, overwriting any previous log with that name.
    #Log directory can be overridden with $PROTON_LOG_DIR.
    
    ###### Logging ######

    # Enable logging
    "PROTON_LOG": "0",

    # Write the command Proton sends to Wine for targeted prefix (/prefix/path/launch_command)
    # Helpful to track bound executable
#   "PROTON_LOG_COMMAND_TO_PREFIX": "1",

    ###### Graphics / API ######
    
    #Spoof d3d12 feature level supported by vkd3d. Needed for some d3d12 games to work.
    "VKD3D_FEATURE_LEVEL": "12_2",

    # Disables DX12
#   "PROTON_NO_D3D12": "1",

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

    # Reduce Pulse Latency
    "PROTON_PULSE_LOWLATENCY": "1",

    #Enable Wayland display output. Required for HDR support
    "PROTON_ENABLE_WAYLAND": "1",

    # Enable WoW64 Mode For Wine Prefixes
    "PROTON_USE_WOW64": "1",
    
    #Enable HDR support. Requires Wayland to be enabled and for HDR to be enabled in system settings.
#    "PROTON_ENABLE_HDR": "1",

    # Enable Winetricks prompt on game launch
#   "PROTON_WINETRICKS": "1",

    #Alternative way to run executables directly with wine binary instead of using steam.exe. This is the preffered way when using proton standalone.
#   "PROTON_STANDALONE_START": "1",

    ###### AMD FSR ######

    # Enable automatic upgrading of AMD FidelityFX Super Resolution (FSR) to FSR4.
#   "PROTON_FSR4_UPGRADE": "1",

    #Disable/Enable AMD FidelityFX Super Resolution (FSR), as it is enabled by default. FSR only works in vulkan games (dxvk and vkd3d-proton included).
#   "WINE_FULLSCREEN_FSR": "0",

    # Set FSR mode: ultra, quality, balanced, performance
#   "WINE_FULLSCREEN_FSR_MODE": "performance",

    # Custom resolution for FSR
#   "WINE_FULLSCREEN_FSR_CUSTOM_MODE": "1920x1080",

    # FSR sharpening (0–5, lower is sharper). #2 is the AMD recommended default and is set by proton-ge.
#   "WINE_FULLSCREEN_FSR_STRENGTH": "2",

    ###### NVIDIA NVAPI / DLSS ######

    # Enable nvapi support (for DLSS)
#   "PROTON_ENABLE_NVAPI": "1",

    # Disable nvapi and nvapi64
    "PROTON_NVAPI_DISABLE": "1",

    ###### Sync Primitives ######

    # Disable eventfd-based in-process synchronization primitives
    "PROTON_NO_ESYNC": "1",

    # Disable futex-based in-process synchronization primitives
#   "PROTON_NO_FSYNC": "1",

    # Disable futex2-based in-process synchronization primitives
#   "PROTON_NO_FUTEX2": "1",

    # Disable support for fast (one syscall per NT syscall) synchronization primitives using the winesync driver in the kernel
#   "PROTON_NO_NTSYNC": "1",

    ###### Shader Cache ######

    # Enforce driver shader cache path when Steam's shader pre-caching is disabled
#   "PROTON_BYPASS_SHADERCACHE_PATH": "",

    ###### DXVK ######

    # DXVK debug logging; none|error|warn|info|debug
#   "DXVK_LOG_LEVEL": "info",

    # DXVK debug log; Set to none to disable log file creation entirely, without disabling logging
#   "DXVK_LOG_PATH": "~/",

    # Enables use of the VK_EXT_debug_utils extension for translating performance event markers
#   "DXVK_PERF_EVENTS": "1",

    # Set DXVK config file path
#   "DXVK_CONFIG_FILE": "~/.config/dxvk.conf",

    # Enable DXVK's HUD; devinfo|fps|frametimes|submissions|drawcalls|pipelines|descriptors|memory|allocations|gpuload|version|api|cs|compiler|samplers|ffshaders|swvp|scale=x|opacity=y
    # DXVK_HUD=1 has the same effect as DXVK_HUD=devinfo,fps, and DXVK_HUD=full enables all available HUD elements
#   "DXVK_HUD": "devinfo,fps",

    # Limit the frame rate
#   "DXVK_FRAME_RATE": "60",

    # DXVK pipeline cache; "0" disable|"/some/directory" Defaults to the current working directory of the application
#   "DXVK_STATE_CACHE": "0",

    # Selects devices with a matching Vulkan device name, which can be retrieved with tools such as vulkaninfo
#   "DXVK_FILTER_DEVICE_NAME": "Device Name",

    # Vulkan debug layers. Requires the Vulkan SDK to be installed
#   "VK_INSTANCE_LAYERS": "VK_LAYER_KHRONOS_validation",

    ###### Wine ######

    # Enable integer scaling mode
#   "WINE_FULLSCREEN_INTEGER_SCALING": "1",

    # Wine debug logging
#   "WINEDEBUG": "+timestamp,+pid,+seh,+unwind,+debugstr,+loaddll,+mscoree",

    # VKD3D debug logging
#   "VKD3D_DEBUG": "warn",

    # Wine-mono debug logging
#   "WINE_MONO_TRACE": "E:System.NotImplementedException",
#   "MONO_LOG_LEVEL": "info",

    ###### GStreamer Media ######

    # General purpose media logging
#   "GST_DEBUG": "4",

    # Verbose converter logging (may impact performance)
#   "GST_DEBUG": "4,WINE:7,protonaudioconverter:7,protonaudioconverterbin:7,protonvideoconverter:7",
#   "GST_DEBUG_NO_COLOR": "1",
}
