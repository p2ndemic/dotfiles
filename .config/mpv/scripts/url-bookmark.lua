--[[

    MPV URL-Bookmark Script v2.0

    This script allows you to manage url-bookmarks in MPV.

    Configuration:
        - URL-Bookmarks are stored in ~/.config/mpv/script-opts/url-bookmarks.txt
        [--] mkdir -p ~/.config/mpv/scripts/
        [--] mkdir -p ~/.config/mpv/script-opts/
        [--] touch ~/.config/mpv/script-opts/url-bookmarks.txt
        [--] chmod -R 755 ~/.config/mpv/
        - The format of the file is: URL|Title (optional)

    Keybindings:
        - '/'          Save the current URL to the bookmark list (with duplicate check).
        - 'ctrl + /'   Load the first url-bookmark from the list.
        - 'Alt + /'    Load the last url-bookmark from the list.
        - ','          Navigate to the previous url-bookmark.
        - '.'          Navigate to the next url-bookmark.
        - 'shift + /'  Remove the currently playing url-bookmark [not implemented yet].

    Add the desired hotkeys to input.conf:

        /              script-binding save_current_url_bookmark
        Ctrl+/         script-binding load_first_url_bookmark
        Alt+b          script-binding load_last_url_bookmark
        ,              script-binding prev_url_bookmark
        .              script-binding next_url_bookmark

--]]

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local URL_BOOKMARKS_FILE = "script-opts/url-bookmarks.txt"
local MAX_TITLE_LENGTH = 80

local url_bookmarks = {}
local current_index = 0

-- Чтение закладок из файла
local function read_url_bookmarks()
    url_bookmarks = {}
    local filename = mp.find_config_file(URL_BOOKMARKS_FILE)
    if not filename then return end

    local file = io.open(filename, "r")
    if not file then return end

    for line in file:lines() do
        local url, title = line:match("^(.-)|(.*)$")
        if url and url ~= "" then
            table.insert(url_bookmarks, {
                url = url,
                title = title ~= "" and title or url
            })
        end
    end
    file:close()
end

-- Получение оригинального URL плейлиста
local function get_original_url()
    local playlist = mp.get_property_native("playlist")
    if #playlist > 0 then
        return playlist[1].filename
    end
    return mp.get_property("path")
end

-- Сохранение текущего URL
local function save_current_url_bookmark()
    local path = get_original_url()
    if not path or path == "" then
        mp.osd_message("No media playing")
        return
    end

    local title = mp.get_property("media-title") or path
    title = title:gsub("[\n\r|]", " ") -- Очистка от спецсимволов
    title = title:sub(1, MAX_TITLE_LENGTH)

    -- Проверка на дубликаты
    for _, bm in ipairs(url_bookmarks) do
        if bm.url == path then
            mp.osd_message("URL bookmark already exists: " .. title)
            return
        end
    end

    -- Добавление в файл
    local entry = string.format("%s|%s\n", path, title)
    local filename = mp.command_native({"expand-path", "~~/"..URL_BOOKMARKS_FILE})
    local file = io.open(filename, "a")
    if file then
        file:write(entry)
        file:close()
        read_url_bookmarks() -- Обновляем кэш
        mp.osd_message("URL bookmark saved: " .. title)
    else
        mp.osd_message("Error saving URL bookmark")
    end
end

-- Загрузка закладки по индексу
local function load_url_bookmark(index)
    if #url_bookmarks == 0 then
        mp.osd_message("No URL bookmarks")
        return
    end

    index = math.max(1, math.min(index, #url_bookmarks))
    current_index = index

    local bm = url_bookmarks[index]
    mp.commandv("loadfile", bm.url, "replace")
    mp.osd_message(string.format("URL Bookmark %d/%d: %s", index, #url_bookmarks, bm.title))
end

-- Навигация
local function load_first_url_bookmark() load_url_bookmark(1) end
local function load_last_url_bookmark() load_url_bookmark(#url_bookmarks) end
local function prev_url_bookmark() load_url_bookmark(current_index - 1) end
local function next_url_bookmark() load_url_bookmark(current_index + 1) end

-- Регистрация горячих клавиш
mp.add_key_binding("/", "save_current_url_bookmark", save_current_url_bookmark)
mp.add_key_binding("Ctrl+/", "load_first_url_bookmark", load_first_url_bookmark)
mp.add_key_binding("Alt+/", "load_last_url_bookmark", load_last_url_bookmark)
mp.add_key_binding(",", "prev_url_bookmark", prev_url_bookmark)
mp.add_key_binding(".", "next_url_bookmark", next_url_bookmark)

-- Init
read_url_bookmarks()
