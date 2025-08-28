--[[
    wayland-yt-paste.lua
    works with Wayland!
    install dependencies: 'wl-clipboard-rs' or 'wl-clipboard'
    put the script in the ~/.config/mpv/scripts directory
    modify ~/.config/mpv/input.conf by adding a new binding:
    Ctrl+v script-binding paste-yt-content
--]]

-- Trim whitespace from URL
local function trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

local utils = require 'mp.utils'

local function paste_yt_content()
    -- Get clipboard content (Wayland compatible)
    local handle = io.popen("wl-paste -p 2>/dev/null")
    if not handle then
        mp.osd_message("⚠️ Clipboard access error")
        return
    end

    local url = trim(handle:read("*a"))
    handle:close()
    if url == "" then
        mp.osd_message("⚠️ Clipboard is empty")
        return
    end

    -- Validate URL pattern
    if url:match("^https?://") then
        -- Add to playlist through yt-dlp
        mp.commandv("loadfile", url, "append-play")
        mp.osd_message("Added from clipboard: " .. url:match("([^/]+)/?$"))
    else
        mp.osd_message("⚠️ No valid URL in clipboard")
    end
end

-- Register Ctrl+V binding
mp.add_key_binding("Ctrl+v", "paste-yt-content", paste_yt_content)
