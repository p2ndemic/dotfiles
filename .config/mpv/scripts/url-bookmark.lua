--[[
    https://github.com/p2ndemic
    MPV URL-Bookmark Script v2.5
    This script allows you to manage url-bookmarks in MPV.

    Configuration:
        - URL-Bookmarks are stored in ~/.config/mpv/script-opts/url-bookmarks.txt
        - The format of the file is: URL|Title (optional)

    Keybindings:
        - '/'          Save the current URL to the bookmark list (with duplicate check).
        - 'Alt+/'    Remove the currently playing url-bookmark.
        - 'Alt+,'   Load the first url-bookmark from the list.
        - 'Alt+.'    Load the last url-bookmark from the list.
        - ','          Navigate to the previous url-bookmark.
        - '.'          Navigate to the next url-bookmark.

    Add the desired hotkeys to input.conf:
        /              script-binding save_current_url_bookmark
        Alt+/        script-binding remove_current_url_bookmark
        Alt+,         script-binding load_first_url_bookmark
        Alt+.          script-binding load_last_url_bookmark
        ,              script-binding prev_url_bookmark
        .              script-binding next_url_bookmark
--]]

local mp = require 'mp'
local msg = require 'mp.msg'

-- 🛜 Configuration
local URL_BOOKMARKS_FILE = "script-opts/url-bookmarks.txt"
local URL_BOOKMARKS_PATH = mp.command_native({"expand-path", "~~/"..URL_BOOKMARKS_FILE})
local MAX_TITLE_LENGTH = 80

-- 🗄️ State
local url_bm = {}
local current_index = 0

-- 🧹 Clean title helper
local function sanitize_title(title)
    return title:gsub("[%c|]", " ")          -- Remove control chars and pipes
                :gsub("%s+", " ")            -- Collapse whitespace
                :gsub("^%s*(.-)%s*$", "%1")  -- Trim spaces
                :sub(1, MAX_TITLE_LENGTH)    -- Truncate length
end

-- 🔗 Get current URL
local function get_current_url()
    local playlist = mp.get_property_native("playlist")
    return (#playlist > 0 and playlist[1].filename) or mp.get_property("path")
end

-- 📖 Check if URL exists in bookmarks
local function url_bookmark_exists(url)
    for _, entry in ipairs(url_bm) do
        if entry.url == url then
            return true
        end
    end
    return false
end

-- 📥 Load URL bookmarks
local function load_url_bookmarks()
    url_bm = {}
    local file = io.open(URL_BOOKMARKS_PATH, "r")
    if not file then
        return
    end

    for line in file:lines() do
        local url, title = line:match("^(.-)|(.*)$")
        if url and url ~= "" then
            table.insert(url_bm, {
                url = url,
                title = title ~= "" and sanitize_title(title) or url
            })
        end
    end
    file:close()
end

-- 💾 Save current URL
local function save_current_url_bookmark()
    local url = get_current_url()
    if not url or url == "" then
        return
    end

    local title = sanitize_title(mp.get_property("media-title") or url)

    if url_bookmark_exists(url) then
        mp.osd_message("⚠ URL Bookmark exists: " .. title)
        return
    end

    -- Save to file
    local file = io.open(URL_BOOKMARKS_PATH, "a")
    if not file then
        return
    end

    file:write(string.format("%s|%s\n", url, title))
    file:close()

    table.insert(url_bm, {url = url, title = title})
    mp.osd_message("✔ URL Bookmark saved: " .. title)
end

-- 🗑️ Remove current URL
local function remove_current_url_bookmark()
    local url = get_current_url()
    if not url then
        return
    end

    local filtered_bookmarks = {}
    local found = false

    for _, entry in ipairs(url_bm) do
        if entry.url ~= url then
            table.insert(filtered_bookmarks, entry)
        else
            found = true
        end
    end

    if not found then
        mp.osd_message("URL Bookmark not found")
        return
    end

    -- Update file
    local file = io.open(URL_BOOKMARKS_PATH, "w")
    if not file then
        return
    end

    for _, entry in ipairs(filtered_bookmarks) do
        file:write(string.format("%s|%s\n", entry.url, entry.title))
    end
    file:close()

    url_bm = filtered_bookmarks
    current_index = math.min(current_index, #url_bm)
    mp.osd_message("✔ URL Bookmark removed")
end

-- 🧭 Navigate to bookmark
local function load_url_bookmark(index)
    if #url_bm == 0 then
        mp.osd_message("No URL Bookmarks")
        current_index = 0
        return
    end

    index = math.max(1, math.min(index, #url_bm))
    current_index = index

    mp.commandv("loadfile", url_bm[index].url, "replace")
    mp.osd_message(string.format("URL Bookmark %d/%d: %s", index, #url_bm, url_bm[index].title))
end


-- 🔄 Navigation helpers
local function first_url_bookmark()
    load_url_bookmark(1)
end

local function last_url_bookmark()
    load_url_bookmark(#url_bm)
end

local function prev_url_bookmark()
    load_url_bookmark(current_index - 1)
end

local function next_url_bookmark()
    load_url_bookmark(current_index + 1)
end

-- ⌨️ Register bindings
mp.add_key_binding(nil, "save_current_url_bookmark", save_current_url_bookmark)
mp.add_key_binding(nil, "remove_current_url_bookmark", remove_current_url_bookmark)
mp.add_key_binding(nil, "load_first_url_bookmark", first_url_bookmark)
mp.add_key_binding(nil, "load_last_url_bookmark", last_url_bookmark)
mp.add_key_binding(nil, "prev_url_bookmark", prev_url_bookmark)
mp.add_key_binding(nil, "next_url_bookmark", next_url_bookmark)

-- 🚀 Initialize
load_url_bookmarks()
