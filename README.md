<img width=150 height=50 align=right src="https://archlinux.org/static/logos/archlinux-logo-light-1200dpi.7ccd81fd52dc.png">

# Arch Linux Dotfiles

dotfiles are the files that starts with a . (dot). This files are generally responsible for software configurations. This repository contains my favorite and most used dotfiles in my Arch Linux setup. 

| **Module Type**              | **Module Name** |
|------------------------------|------|
| **OS**                       | [Arch Linux](https://archlinux.org/) \| [CachyOS](https://cachyos.org/) |
| **Display Manager**          | [ly](https://codeberg.org/fairyglade/ly) \| [gdm](https://gitlab.gnome.org/GNOME/gdm.git) \| [greetd](https://git.sr.ht/~kennylevinsen/greetd) + [regreet](https://github.com/rharish101/ReGreet) |
| **Wayland Compositor**       | [sway](https://github.com/swaywm/sway)
| **Wayland Protocols**        | [wayland-protocols](https://gitlab.freedesktop.org/wayland/wayland-protocols) + [wlr-protocols](https://gitlab.freedesktop.org/wlroots/wlr-protocols) + [frog-protocols](https://github.com/misyltoad/frog-protocols) |
| **XDG Portal**               | [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) |
| **Session Access Manager**   | [polkit](https://github.com/polkit-org/polkit) |
| **Power Daemon**             | [tuned](https://github.com/redhat-performance/tuned) + [tuned-gui](https://github.com/redhat-performance/tuned) |
| **Power Alert Daemon**       | [poweralertd](https://sr.ht/~kennylevinsen/poweralertd/) |
| **Network Management Tool**  | [networkmanager](https://networkmanager.dev) + [nm-connection-editor](https://gitlab.gnome.org/GNOME/network-manager-applet) |
| **Idle Management Daemon**   | [swayidle](https://github.com/swaywm/swayidle) |
| **Display configuration tool**| [wlr-randr[opt]](https://gitlab.freedesktop.org/emersion/wlr-randr) \| [kanshi[opt]](https://sr.ht/~emersion/kanshi) \| [shikane[opt]](https://gitlab.com/w0lff/shikane)|
| **Shell**                    | [fish](https://github.com/fish-shell/fish-shell) + [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish) |
| **Terminal Emulator**        | [foot](https://codeberg.org/dnkl/foot) |
| **Application Launcher**     | [fuzzel](https://codeberg.org/dnkl/fuzzel) \| [walker](https://github.com/abenz1267/walker)|
| **Notification Daemon**      | [fnott](https://codeberg.org/dnkl/fnott) \| [mako](https://github.com/emersion/mako)|
| **Bar**                      | [waybar](https://github.com/Alexays/Waybar) \| [ironbar](https://github.com/JakeStanger/ironbar)|
| **OSD**                      | [swayosd](https://github.com/ErikReider/SwayOSD) \| [wob](https://github.com/francma/wob) |
| **Wallpaper Tool**           |[swaybg](https://github.com/swaywm/swaybg) \| [wpaperd](https://github.com/danyspin97/wpaperd) \| [wallutils](https://github.com/xyproto/wallutils)| 
| **Lockscreen & Logout menu** | [swaylock](https://github.com/swaywm/swaylock) \| [waylock](https://codeberg.org/ifreund/waylock) + [wleave](https://github.com/AMNatty/wleave) |
| **Configuration Tools**      | [swaysettings](https://github.com/ErikReider/SwaySettings) + [nwg-displays](https://github.com/nwg-piotr/nwg-displays)|
| **Brightness Adjustments Tool**| [brightnessctl](https://github.com/Hummer12007/brightnessctl) |
| **Gamma Adjustments Tool**   | [wlsunset](https://git.sr.ht/~kennylevinsen/wlsunset) |
| **GUI File Manager**         | [pcmanfm-qt](https://github.com/lxqt/pcmanfm-qt) \| [nautilus](https://wiki.gnome.org/Apps/Files) |
| **Terminal File Manager**     | [yazi](https://github.com/sxyazi/yazi)|
| **Clipboard**                | [wl-clipboard-rs](https://github.com/YaLTeR/wl-clipboard-rs) + [cliphist](https://github.com/sentriz/cliphist) \| [clipse](https://github.com/savedra1/clipse) \| [clipvault](https://github.com/rolv-apneseth/clipvault)|
| **Screenshot Software**      | [wayshot](https://git.sr.ht/~shinyzenith/wayshot) \| [grimshot](https://github.com/OctopusET/sway-contrib) \| [shotman](https://git.sr.ht/~whynothugo/shotman)|
| **Screen Recording**         | [wl-screenrec](https://github.com/russelltg/wl-screenrec) \| [gpu-screen-recorder](https://git.dec05eba.com/gpu-screen-recorder/about/) \| [obs](https://obsproject.com) |
| **System Monitoring**        | [btop](https://github.com/aristocratos/btop)|
| **GUI Text Editor**          | [zed](https://github.com/zed-industries/zed) \| [vscode](https://wiki.archlinux.org/title/Visual_Studio_Code) |
| **Terminal Text Editor**      | [micro](https://github.com/zyedidia/micro) \| [orbiton](https://github.com/xyproto/orbiton) \| [nano](https://cgit.git.savannah.gnu.org/cgit/nano.git) |
| **Multimedia Control Tools** | [playerctl](https://github.com/altdesktop/playerctl) + [pwvucontrol](https://github.com/saivert/pwvucontrol) \| [easyeffects](https://github.com/wwmm/easyeffects)|
| **Media Player**             | [mpv](https://github.com/mpv-player/mpv) + [yt-dlp](https://github.com/yt-dlp/yt-dlp) |
| **Audio Player**             | [rmpc](https://github.com/mierak/rmpc) \| [ncspot](https://github.com/hrkfdn/ncspot) |
| **Audio Visualizer**         | [cava](https://github.com/karlstav/cava) \| [musializer](https://github.com/tsoding/musializer) |
| **PDF Reader**               | [zathura](https://github.com/pwmt/zathura) |
| **Image Viewer**             | [oculante](https://github.com/woelper/oculante) |
| **Clock**                    | [tenki](https://github.com/ckaznable/tenki) |
| **Fetch**                    | [fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| **Terminal Visuals**         | [ascii-rain](https://github.com/nkleemann/ascii-rain) |
| **Notes**                    | [obsidian](https://obsidian.md) \| [AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) + [notesnook](https://notesnook.com) |
| **Bookmark manager**         | [raindrop](https://raindrop.io) |
| **Emoji picker**             | [bemoji](https://github.com/marty-oehme/bemoji) |
| **Theme manager**            | [kvantum](https://github.com/tsujan/Kvantum) + [nwg-look](https://github.com/nwg-piotr/nwg-look)|
| **GTK Theme**                | [libadwaita](https://gitlab.gnome.org/GNOME/libadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| **QT Theme**                 | [kvlibadwaita](https://github.com/GabePoel/KvLibadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| **Icons**                    | [papirus Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) |
| **Fonts**                    | [nerd fonts](https://github.com/ryanoasis/nerd-fonts) |
| **Misc**                     | [wayfreeze](https://github.com/Jappie3/wayfreeze) \| [arch-update](https://github.com/Antiz96/arch-update)
| **Utils**            | [fzf](https://github.com/junegunn/fzf) \| [skim](https://github.com/skim-rs/skim) \| [dua-cli](https://github.com/Byron/dua-cli) \| [bandwhich](https://github.com/imsnif/bandwhich) \| [pik](https://github.com/jacek-kurlit/pik) \| [kmon](https://github.com/orhun/kmon) \| [iotop](https://github.com/Tomas-M/iotop) \| [nvtop](https://github.com/Syllo/nvtop) \| [systemd-manager-tui](https://github.com/matheus-git/systemd-manager-tui) \| [s-tui](https://github.com/amanusk/s-tui) \| [navi](https://github.com/denisidoro/navi) \| [powertop](https://github.com/fenrus75/powertop) \| [laptop-mode-tools](https://github.com/rickysarraf/laptop-mode-tools/) \| [thermald](https://github.com/intel/thermal_daemon) \| [eza](https://github.com/eza-community/eza) \| [bat](https://github.com/sharkdp/bat) \| [ripgrep](https://github.com/BurntSushi/ripgrep) \| [fd](https://github.com/sharkdp/fd) \| [inxi](https://codeberg.org/smxi/inxi) \| [broot](https://github.com/Canop/broot) \| [fselect](https://github.com/jhspetersson/fselect) \| [starship](https://github.com/starship/starship) \| [wluma](https://github.com/maximbaz/wluma) \| [netdata](https://github.com/netdata/netdata) \| [neohtop](https://github.com/Abdenasser/neohtop) \| [planify](https://github.com/alainm23/planify) \| [nvtop](https://github.com/Syllo/nvtop) \| [iftop](https://code.blinkace.com/pdw/iftop) \| [duf](https://github.com/muesli/duf) \| [mission-center](https://gitlab.com/mission-center-devs/mission-center) \| [wavemon](https://github.com/uoaerg/wavemon) \| [xdg-ninja](https://github.com/b3nj5m1n/xdg-ninja) \| [woomer](https://github.com/coffeeispower/woomer) \| [vigiland](https://github.com/Jappie3/vigiland) \| [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) \| [glances](https://github.com/nicolargo/glances) \| [resources](https://github.com/nokyan/resources) \| [s-tui](https://github.com/amanusk/s-tui) \| [watershot](https://github.com/Kirottu/watershot) \| [jq](https://jqlang.org) \| [satty](https://github.com/gabm/satty) \| [hyprfreeze](https://github.com/Zerodya/hyprfreeze) \| [acpid](https://wiki.archlinux.org/title/Acpid) \| [satty](https://github.com/gabm/satty) \| [usql](https://github.com/xo/usql) \| []() \| []() \| []()|
### 🔨 Dependencies
#### Packages
  - sway
  - todo ...
#### Fonts
  - nerd-fonts
  - todo ...

## Installation

There is no installation script yet, but in the meantime you can clone the repo and copy the contents of the `./config` folder into your `./config` folder.

<u>Example</u>:

```
git clone https://github.com/p2ndemic/dotfiles.git
cp -r dotfiles/.config/* ~/.config
```

### TODO

- [ ] Add installation script
- [ ] Better documentation

## Screenshots

<table>
  <tr>
    <th>Module Type</th>
    <th>Module Name</th>
  </tr>
  <tr>
    <th rowspan="2">OS</th>
    <td><a href="https://archlinux.org/">Arch Linux</a></td>
  </tr>
  <tr>
    <td><a href="https://cachyos.org/">CachyOS</a></td>
  </tr>
  <tr>
    <th rowspan="3">Display Manager</th>
    <td><a href="https://codeberg.org/fairyglade/ly">ly</a></td>
  </tr>
  <tr>
    <td><a href="https://gitlab.gnome.org/GNOME/gdm">gdm</a></td>
  </tr>
  <tr>
    <td><a href="https://git.sr.ht/~kennylevinsen/greetd">greetd</a> + <a href="https://github.com/rharish101/ReGreet">ReGreet</a></td>
  </tr>
  <tr>
    <th>Wayland Compositor</th>
    <td><a href="https://github.com/swaywm/sway">sway</a></td>
  </tr>
  <tr>
    <th>Wayland Protocols</th>
    <td><a href="https://gitlab.freedesktop.org/wayland/wayland-protocols">wayland-protocols</a> + <a href="https://gitlab.freedesktop.org/wlroots/wlr-protocols">wlr-protocols</a> + <a href="https://github.com/misyltoad/frog-protocols">frog-protocols</a></td>
  </tr>
  <tr>
    <th>XDG Portal</th>
    <td><a href="https://github.com/emersion/xdg-desktop-portal-wlr">xdg-desktop-portal-wlr</a></td>
  </tr>
  <tr>
    <th>Session Access Manager</th>
    <td><a href="https://github.com/polkit-org/polkit">polkit</a></td>
  </tr>
  <tr>
    <th>Power Daemon</th>
    <td><a href="https://github.com/redhat-performance/tuned">tuned</a> + <a href="https://github.com/redhat-performance/tuned">tuned-gui</a></td>
  </tr>
  <tr>
    <th>Power Alert Daemon</th>
    <td><a href="https://sr.ht/~kennylevinsen/poweralertd/">poweralertd</a></td>
  </tr>
  <tr>
    <th>Network Management Tool</th>
    <td><a href="https://networkmanager.dev">networkmanager</a> + <a href="https://gitlab.gnome.org/GNOME/network-manager-applet">nm-connection-editor</a></td>
  </tr>
  <tr>
    <th>Idle Management Daemon</th>
    <td><a href="https://github.com/swaywm/swayidle">swayidle</a></td>
  </tr>
  <tr>
    <th rowspan="3">Display configuration tool \n[optional]</th>
    <td><a href="https://gitlab.freedesktop.org/emersion/wlr-randr">wlr-randr</a></td>
  </tr>
  <tr>
    <td><a href="https://sr.ht/~emersion/kanshi">kanshi</a></td>
  </tr>
  <tr>
    <td><a href="https://gitlab.com/w0lff/shikane">shikane</a></td>
  </tr>
  <tr>
    <th>Shell</th>
    <td><a href="https://github.com/fish-shell/fish-shell">fish</a> + <a href="https://github.com/oh-my-fish/oh-my-fish">oh-my-fish</a></td>
  </tr>
  <tr>
    <th>Terminal Emulator</th>
    <td><a href="https://codeberg.org/dnkl/foot">foot</a></td>
  </tr>
  <tr>
    <th rowspan="2">Application Launcher</th>
    <td><a href="https://codeberg.org/dnkl/fuzzel">fuzzel</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/abenz1267/walker">walker</a></td>
  </tr>
  <tr>
    <th rowspan="2">Notification Daemon</th>
    <td><a href="https://codeberg.org/dnkl/fnott">fnott</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/emersion/mako">mako</a></td>
  </tr>
  <tr>
    <th rowspan="2">Bar</th>
    <td><a href="https://github.com/Alexays/Waybar">waybar</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/JakeStanger/ironbar">ironbar</a></td>
  </tr>
  <tr>
    <th rowspan="2">OSD</th>
    <td><a href="https://github.com/ErikReider/SwayOSD">swayosd</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/francma/wob">wob</a></td>
  </tr>
  <tr>
    <th rowspan="3">Wallpaper Tool</th>
    <td><a href="https://github.com/swaywm/swaybg">swaybg</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/danyspin97/wpaperd">wpaperd</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/xyproto/wallutils">wallutils</a></td>
  </tr>
  <tr>
    <th rowspan="2">Lockscreen &amp; Logout menu</th>
    <td><a href="https://github.com/swaywm/swaylock">swaylock</a></td>
  </tr>
  <tr>
    <td><a href="https://codeberg.org/ifreund/waylock">waylock</a> + <a href="https://github.com/AMNatty/wleave">wleave</a></td>
  </tr>
  <tr>
    <th>Configuration Tools</th>
    <td><a href="https://github.com/ErikReider/SwaySettings">swaysettings</a> + <a href="https://github.com/nwg-piotr/nwg-displays">nwg-displays</a></td>
  </tr>
  <tr>
    <th>Brightness Adjustments Tool</th>
    <td><a href="https://github.com/Hummer12007/brightnessctl">brightnessctl</a></td>
  </tr>
  <tr>
    <th>Gamma Adjustments Tool</th>
    <td><a href="https://git.sr.ht/~kennylevinsen/wlsunset">wlsunset</a></td>
  </tr>
  <tr>
    <th rowspan="2">GUI File Manager</th>
    <td><a href="https://github.com/lxqt/pcmanfm-qt">pcmanfm-qt</a></td>
  </tr>
  <tr>
    <td><a href="https://wiki.gnome.org/Apps/Files">nautilus</a></td>
  </tr>
  <tr>
    <th>Terminal File Manager</th>
    <td><a href="https://github.com/sxyazi/yazi">yazi</a></td>
  </tr>
  <tr>
    <th rowspan="3">Clipboard</th>
    <td><a href="https://github.com/YaLTeR/wl-clipboard-rs">wl-clipboard-rs</a> + <a href="https://github.com/sentriz/cliphist">cliphist</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/savedra1/clipse">clipse</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/rolv-apneseth/clipvault">clipvault</a></td>
  </tr>
  <tr>
    <th rowspan="2">Screenshot Software</th>
    <td><a href="https://git.sr.ht/~shinyzenith/wayshot">wayshot</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/swaywm/sway/blob/master/contrib/grimshot">grimshot</a></td>
  </tr>
  <tr>
    <th rowspan="3">Screen Recording</th>
    <td><a href="https://github.com/russelltg/wl-screenrec">wl-screenrec</a></td>
  </tr>
  <tr>
    <td><a href="https://git.dec05eba.com/gpu-screen-recorder/about/">gpu-screen-recorder</a></td>
  </tr>
  <tr>
    <td><a href="https://obsproject.com">obs</a></td>
  </tr>
  <tr>
    <th>System Monitoring</th>
    <td><a href="https://github.com/aristocratos/btop">btop</a></td>
  </tr>
  <tr>
    <th rowspan="2">GUI Text Editor</th>
    <td><a href="https://github.com/zed-industries/zed">zed</a></td>
  </tr>
  <tr>
    <td><a href="https://wiki.archlinux.org/title/Visual_Studio_Code">vscode</a></td>
  </tr>
  <tr>
    <th rowspan="3">Terminal Text Editor</th>
    <td><a href="https://github.com/zyedidia/micro">micro</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/xyproto/orbiton">orbiton</a></td>
  </tr>
  <tr>
    <td><a href="https://cgit.git.savannah.gnu.org/cgit/nano.git">nano</a></td>
  </tr>
  <tr>
    <th rowspan="2">Multimedia Control Tools</th>
    <td><a href="https://github.com/altdesktop/playerctl">playerctl</a> + <a href="https://github.com/saivert/pwvucontrol">pwvucontrol</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/wwmm/easyeffects">easyeffects</a></td>
  </tr>
  <tr>
    <th>Media Player</th>
    <td><a href="https://github.com/mpv-player/mpv">mpv</a> + <a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a></td>
  </tr>
  <tr>
    <th rowspan="2">Audio Player</th>
    <td><a href="https://github.com/mierak/rmpc">rmpc</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/hrkfdn/ncspot">ncspot</a></td>
  </tr>
  <tr>
    <th rowspan="2">Audio Visualizer</th>
    <td><a href="https://github.com/karlstav/cava">cava</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/tsoding/musializer">musializer</a></td>
  </tr>
  <tr>
    <th>PDF Reader</th>
    <td><a href="https://github.com/pwmt/zathura">zathura</a></td>
  </tr>
  <tr>
    <th>Image Viewer</th>
    <td><a href="https://github.com/woelper/oculante">oculante</a></td>
  </tr>
  <tr>
    <th>Clock</th>
    <td><a href="https://github.com/ckaznable/tenki">tenki</a></td>
  </tr>
  <tr>
    <th>Fetch</th>
    <td><a href="https://github.com/fastfetch-cli/fastfetch">fastfetch</a></td>
  </tr>
  <tr>
    <th>Terminal Visuals</th>
    <td><a href="https://github.com/nkleemann/ascii-rain">ascii-rain</a></td>
  </tr>
  <tr>
    <th rowspan="2">Notes</th>
    <td><a href="https://obsidian.md">obsidian</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/AppFlowy-IO/AppFlowy">AppFlowy</a> + <a href="https://notesnook.com">notesnook</a></td>
  </tr>
  <tr>
    <th>Bookmark manager</th>
    <td><a href="https://raindrop.io">raindrop</a></td>
  </tr>
  <tr>
    <th>Emoji picker</th>
    <td><a href="https://github.com/marty-oehme/bemoji">bemoji</a></td>
  </tr>
  <tr>
    <th>Theme manager</th>
    <td><a href="https://github.com/tsujan/Kvantum">kvantum</a> + <a href="https://github.com/nwg-piotr/nwg-look">nwg-look</a></td>
  </tr>
  <tr>
    <th rowspan="3">GTK Theme</th>
    <td><a href="https://gitlab.gnome.org/GNOME/libadwaita">libadwaita</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/EliverLara/Nordic">nordic</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/anufrievroman/whale">whale</a></td>
  </tr>
  <tr>
    <th rowspan="3">QT Theme</th>
    <td><a href="https://github.com/GabePoel/KvLibadwaita">kvlibadwaita</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/EliverLara/Nordic">nordic</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/anufrievroman/whale">whale</a></td>
  </tr>
  <tr>
    <th>Icons</th>
    <td><a href="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme">papirus Dark</a></td>
  </tr>
  <tr>
    <th>Fonts</th>
    <td><a href="https://github.com/ryanoasis/nerd-fonts">nerd fonts</a></td>
  </tr>
  <tr>
    <th rowspan="2">Misc</th>
    <td><a href="https://github.com/Jappie3/wayfreeze">wayfreeze</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Antiz96/arch-update">arch-update</a></td>
  </tr>
  <tr>
    <th rowspan="49">Utils</th>
    <td><a href="https://github.com/junegunn/fzf">fzf</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/skim-rs/skim">skim</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Byron/dua-cli">dua-cli</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/imsnif/bandwhich">bandwhich</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/jacek-kurlit/pik">pik</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/orhun/kmon">kmon</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Tomas-M/iotop">iotop</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Syllo/nvtop">nvtop</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/matheus-git/systemd-manager-tui">systemd-manager-tui</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/amanusk/s-tui">s-tui</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/denisidoro/navi">navi</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/fenrus75/powertop">powertop</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/rickysarraf/laptop-mode-tools/">laptop-mode-tools</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/intel/thermal_daemon">thermald</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/eza-community/eza">eza</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/sharkdp/bat">bat</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/BurntSushi/ripgrep">ripgrep</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/sharkdp/fd">fd</a></td>
  </tr>
  <tr>
    <td><a href="https://codeberg.org/smxi/inxi">inxi</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Canop/broot">broot</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/jhspetersson/fselect">fselect</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/starship/starship">starship</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/maximbaz/wluma">wluma</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/netdata/netdata">netdata</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Abdenasser/neohtop">neohtop</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/alainm23/planify">planify</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Syllo/nvtop">nvtop</a></td>
  </tr>
  <tr>
    <td><a href="https://code.blinkace.com/pdw/iftop">iftop</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/muesli/duf">duf</a></td>
  </tr>
  <tr>
    <td><a href="https://gitlab.com/mission-center-devs/mission-center">mission-center</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/uoaerg/wavemon">wavemon</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/b3nj5m1n/xdg-ninja">xdg-ninja</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/coffeeispower/woomer">woomer</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Jappie3/vigiland">vigiland</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/JanDeDobbeleer/oh-my-posh">oh-my-posh</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/nicolargo/glances">glances</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/nokyan/resources">resources</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/amanusk/s-tui">s-tui</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Kirottu/watershot">watershot</a></td>
  </tr>
  <tr>
    <td><a href="https://jqlang.org">jq</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/gabm/satty">satty</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/Zerodya/hyprfreeze">hyprfreeze</a></td>
  </tr>
  <tr>
    <td><a href="https://wiki.archlinux.org/title/Acpid">acpid</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/gabm/satty">satty</a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/xo/usql">usql</a></td>
  </tr>
</table>

https://github.com/GabePoel/KvLibadwaita
https://github.com/avtzis/awesome-linux-ricing?tab=readme-ov-file


---

## 🖥️ Operating Systems & Core Components

| Category | Programs |
|----------|----------|
| **OS**   | [Arch Linux](https://archlinux.org) \| [CachyOS](https://cachyos.org) |

---

## 🚪 Display & Login Managers

| Category             | Programs |
|----------------------|----------|
| **Display Managers** | [ly](https://codeberg.org/fairyglade/ly) \| [gdm](https://gitlab.gnome.org/GNOME/gdm.git) \| [greetd](https://git.sr.ht/~kennylevinsen/greetd) + [regreet](https://github.com/rharish101/ReGreet) |

---

## 🖼️ Graphics Stack: Wayland & X11

| Category                      | Programs |
|-------------------------------|----------|
| **Wayland Compositors**       | [sway](https://github.com/swaywm/sway) |
| **Wayland Protocols**         | [wayland-protocols](https://gitlab.freedesktop.org/wayland/wayland-protocols) + [wlr-protocols](https://gitlab.freedesktop.org/wlroots/wlr-protocols) + [frog-protocols](https://github.com/misyltoad/frog-protocols) |
| **Portals**                   | [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) |
| **Session Access Control**    | [polkit](https://github.com/polkit-org/polkit) |

---

## ⚡ Power & System Resource Management

| Category                  | Programs |
|---------------------------|----------|
| **Power Daemons**         | [tuned](https://github.com/redhat-performance/tuned) + [tuned-gui](https://github.com/redhat-performance/tuned) \| [poweralertd](https://sr.ht/~kennylevinsen/poweralertd/) |
| **System Monitoring**     | [btop](https://github.com/aristocratos/btop) \| [glances](https://github.com/nicolargo/glances) \| [resources](https://github.com/nokyan/resources) \| [kmon](https://github.com/orhun/kmon) \| [nvtop](https://github.com/Syllo/nvtop) \| [iotop](https://github.com/Tomas-M/iotop) \| [iftop](https://code.blinkace.com/pdw/iftop) \| [bandwhich](https://github.com/imsnif/bandwhich) \| [netdata](https://github.com/netdata/netdata) |
| **Thermal & Power Tuning**| [s-tui](https://github.com/amanusk/s-tui) \| [powertop](https://github.com/fenrus75/powertop) \| [thermald](https://github.com/intel/thermal_daemon) \| [laptop-mode-tools](https://github.com/rickysarraf/laptop-mode-tools/) |

---

## 🌐 Networking & System Utilities

| Category               | Programs |
|------------------------|----------|
| **Network Management** | [networkmanager](https://networkmanager.dev) + [nm-connection-editor](https://gitlab.gnome.org/GNOME/network-manager-applet) |
| **System Utils**       | [acpid](https://wiki.archlinux.org/title/Acpid) \| [systemd-manager-tui](https://github.com/matheus-git/systemd-manager-tui) |
| **System Info**        | [inxi](https://codeberg.org/smxi/inxi) \| [fastfetch](https://github.com/fastfetch-cli/fastfetch) |

---

## 🖱️ Shell, Terminal & Workspace Tools

| Category                 | Programs |
|--------------------------|----------|
| **Shell & Frameworks**   | [fish](https://github.com/fish-shell/fish-shell) + [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish) \| [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) |
| **Terminal Emulators**   | [foot](https://codeberg.org/dnkl/foot) |
| **Terminal Utilities**   | [fzf](https://github.com/junegunn/fzf) \| [skim](https://github.com/skim-rs/skim) \| [eza](https://github.com/eza-community/eza) \| [bat](https://github.com/sharkdp/bat) \| [ripgrep](https://github.com/BurntSushi/ripgrep) \| [fd](https://github.com/sharkdp/fd) \| [dua-cli](https://github.com/Byron/dua-cli) \| [duf](https://github.com/muesli/duf) \| [broot](https://github.com/Canop/broot) \| [fselect](https://github.com/jhspetersson/fselect) \| [navi](https://github.com/denisidoro/navi) \| [jq](https://jqlang.org) \| [usql](https://github.com/xo/usql) \| [fselect](https://github.com/jhspetersson/fselect) |
| **Launchers & Menus**    | [fuzzel](https://codeberg.org/dnkl/fuzzel) \| [walker](https://github.com/abenz1267/walker) |
| **Bars & OSD**           | [waybar](https://github.com/Alexays/Waybar) \| [ironbar](https://github.com/JakeStanger/ironbar) / [swayosd](https://github.com/ErikReider/SwayOSD) \| [wob](https://github.com/francma/wob) |
| **OSD**                  | [swayosd](https://github.com/ErikReider/SwayOSD) \| [wob](https://github.com/francma/wob) |
| **Notification Daemon**  | [fnott](https://codeberg.org/dnkl/fnott) \| [mako](https://github.com/emersion/mako)|
| **Clipboard**            | [wl-clipboard-rs](https://github.com/YaLTeR/wl-clipboard-rs) + [cliphist](https://github.com/sentriz/cliphist) \| [clipse](https://github.com/savedra1/clipse) \| [clipvault](https://github.com/rolv-apneseth/clipvault) |
| **Lock & Logout**        | [swaylock](https://github.com/swaywm/swaylock) \| [waylock](https://codeberg.org/ifreund/waylock) / [wleave](https://github.com/AMNatty/wleave) |
| **Wallpaper Tools**      | [swaybg](https://github.com/swaywm/swaybg) \| [wpaperd](https://github.com/danyspin97/wpaperd) \| [wallutils](https://github.com/xyproto/wallutils) |
| **Config Tools**         | [swaysettings](https://github.com/ErikReider/SwaySettings) + [nwg-displays](https://github.com/nwg-piotr/nwg-displays) + [nwg-look](https://github.com/nwg-piotr/nwg-look) |
| **Output configuration** | [wlr-randr](https://gitlab.freedesktop.org/emersion/wlr-randr) \| [kanshi](https://sr.ht/~emersion/kanshi) \| [shikane](https://gitlab.com/w0lff/shikane) |
| **Display Adjustment**   | [brightnessctl](https://github.com/Hummer12007/brightnessctl) \| [wlsunset](https://git.sr.ht/~kennylevinsen/wlsunset) |
| **Idle Management**      | [swayidle](https://github.com/swaywm/swayidle) |

---

## 📸 Multimedia: Screenshots, Recording, Audio/Video

| Category              | Programs |
|-----------------------|----------|
| **Screenshots**       | [wayshot](https://git.sr.ht/~shinyzenith/wayshot) \| [grimshot](https://github.com/swaywm/sway/blob/master/contrib/grimshot) \| [satty](https://github.com/gabm/satty) \| [watershot](https://github.com/Kirottu/watershot) |
| **Screen Recording**  | [wl-screenrec](https://github.com/russelltg/wl-screenrec) \| [gpu-screen-recorder](https://git.dec05eba.com/gpu-screen-recorder/about/) \| [obs](https://obsproject.com) |
| **Multimedia Control**| [playerctl](https://github.com/altdesktop/playerctl) + [pwvucontrol](https://github.com/saivert/pwvucontrol) \| [easyeffects](https://github.com/wwmm/easyeffects)  |
| **Media Players**     | [mpv](https://github.com/mpv-player/mpv) + [yt-dlp](https://github.com/yt-dlp/yt-dlp) |
| **Audio Players**     | [rmpc](https://github.com/mierak/rmpc) \| [ncspot](https://github.com/hrkfdn/ncspot) |
| **Audio Visualizers** | [cava](https://github.com/karlstav/cava) \| [musializer](https://github.com/tsoding/musializer) |

---

## 📁 File Managers

| Category                   | Programs |
|----------------------------|----------|
| **GUI File Managers**      | [pcmanfm-qt](https://github.com/lxqt/pcmanfm-qt) \| [nautilus](https://wiki.gnome.org/Apps/Files) |
| **Terminal File Managers** | [yazi](https://github.com/sxyazi/yazi) |

---

## ✍️ Text Editors

| Category          | Programs |
|-------------------|----------|
| **GUI Editors**   | [zed](https://github.com/zed-industries/zed) \| [vscode](https://wiki.archlinux.org/title/Visual_Studio_Code) |
| **Terminal Editors** | [micro](https://github.com/zyedidia/micro) \| [orbiton](https://github.com/xyproto/orbiton) \| [nano](https://cgit.git.savannah.gnu.org/cgit/nano.git) |

---

## 📚 Readers & Viewers

| Category         | Programs |
|------------------|----------|
| **PDF Reader**   | [zathura](https://github.com/pwmt/zathura) |
| **Image Viewer** | [oculante](https://github.com/woelper/oculante) |
| **Clock/Weather**| [tenki](https://github.com/ckaznable/tenki) |

---

## 🎨 Themes, Icons & Appearance

| Category         | Programs |
|------------------|----------|
| **Theme Managers**| [kvantum](https://github.com/tsujan/Kvantum) + [nwg-look](https://github.com/nwg-piotr/nwg-look) |
| **GTK Themes**   | [libadwaita](https://gitlab.gnome.org/GNOME/libadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| **QT Themes**    | [kvlibadwaita](https://github.com/GabePoel/KvLibadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| **Icons**        | [papirus Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) |
| **Fonts**        | [nerd fonts](https://github.com/ryanoasis/nerd-fonts) |

---

## 🧩 Miscellaneous & Utilities

| Category            | Programs |
|---------------------|----------|
| **Notes**           | [obsidian](https://obsidian.md) \| [AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) \| [notesnook](https://notesnook.com) |
| **Bookmarks**       | [raindrop](https://raindrop.io) |
| **Emoji Picker**    | [bemoji](https://github.com/marty-oehme/bemoji) |
| **Terminal Visuals**| [ascii-rain](https://github.com/nkleemann/ascii-rain) |
| **System Utils**    | [arch-update](https://github.com/Antiz96/arch-update) \| [xdg-ninja](https://github.com/b3nj5m1n/xdg-ninja) \| [wluma](https://github.com/maximbaz/wluma) \| [planify](https://github.com/alainm23/planify) \| [mission-center](https://gitlab.com/mission-center-devs/mission-center) \| [wavemon](https://github.com/uoaerg/wavemon) \| [pik](https://github.com/jacek-kurlit/pik) |
| **Freeze/Block**    | [wayfreeze](https://github.com/Jappie3/wayfreeze) \| [hyprfreeze](https://github.com/Zerodya/hyprfreeze) \| [vigiland](https://github.com/Jappie3/vigiland) \| [woomer](https://github.com/coffeeispower/woomer) |

---


Конечно! Ниже — ваш список, аккуратно отформатированный, выровненный и визуально улучшенный для лучшей читаемости и эстетики. Я сохранил все ссылки, добавил немного структуры и единообразия, а также убрал лишние пробелы и артефакты (например, `/bemoji)` в конце таблицы).


## 🖥️ OS & Core Components

| Module Type | Module Name |
|-------------|-------------|
| 🧰 Operating System        | [Arch Linux](https://archlinux.org/) \| [CachyOS](https://cachyos.org/) |
| ⚡ Power daemon            | [tuned](https://github.com/redhat-performance/tuned) + [tuned-gui](https://github.com/redhat-performance/tuned) |
| 🔋 Power Alert Daemon      | [poweralertd](https://sr.ht/~kennylevinsen/poweralertd/) |
| 📶 Network Management tool | [NetworkManager](https://networkmanager.dev/) + [nm-connection-editor](https://gitlab.gnome.org/GNOME/network-manager-applet) |
| 🧊 Idle Daemon             | [swayidle](https://github.com/swaywm/swayidle) |

---

## 🖼️ Display Managers & Wayland Stack

| Module Type | Module Name |
|-------------|-------------|
| 🚪 Display Manager        | [ly](https://codeberg.org/fairyglade/ly) \| [gdm](https://gitlab.gnome.org/GNOME/gdm.git) \| [greetd](https://git.sr.ht/~kennylevinsen/greetd) + [regreet](https://github.com/rharish101/ReGreet) |
| 🪟 Wayland Compositor     | [sway](https://github.com/swaywm/sway) |
| 📜 Wayland Protocols      | [wayland-protocols](https://gitlab.freedesktop.org/wayland/wayland-protocols) + [wlr-protocols](https://gitlab.freedesktop.org/wlroots/wlr-protocols) + [frog-protocols](https://github.com/misyltoad/frog-protocols) |
| 🔐 Session Access Manager | [polkit](https://github.com/polkit-org/polkit) |
| 🌀 Portal Backend         | [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) |

---

## 📟 Terminal & Shell

| Module Type | Module Name |
|-------------|-------------|
| 🐟 Shell & Framework | [fish](https://github.com/fish-shell/fish-shell) + [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish) |
| 🖥️ Terminal Emulator | [foot](https://codeberg.org/dnkl/foot) |
| 💫 Shell Enhancers   | [starship](https://github.com/starship/starship) \| [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) |
| 🔍 Terminal Tools    | [fzf](https://github.com/junegunn/fzf) \| [skim](https://github.com/skim-rs/skim) \| [eza](https://github.com/eza-community/eza) \| [bat](https://github.com/sharkdp/bat) \| [ripgrep](https://github.com/BurntSushi/ripgrep) \| [fd](https://github.com/sharkdp/fd) |

---

## 🧩 Workspace Tools

| Module Type | Module Name |
|-------------|-------------|
| 🧱 Bar / Panel         | [waybar](https://github.com/Alexays/Waybar) \| [ironbar](https://github.com/JakeStanger/ironbar) |
| 💡 OSD                 | [swayosd](https://github.com/ErikReider/SwayOSD) \| [wob](https://github.com/francma/wob) |
| 🔔 Notification Daemon | [fnott](https://codeberg.org/dnkl/fnott) \| [mako](https://github.com/emersion/mako) |
| 🎚️ Brightness & Gamma  | [brightnessctl](https://github.com/Hummer12007/brightnessctl) \| [gammastep](https://gitlab.com/chinstrap/gammastep) \| [wlsunset]
(https://git.sr.ht/~kennylevinsen/wlsunset) |
| 🖼️ Wallpaper Tools     | [swaybg](https://github.com/swaywm/swaybg) \| [wpaperd](https://github.com/danyspin97/wpaperd) \| [wallutils](https://github.com/xyproto/wallutils) |
| 🔒 Lockscreen & Logout | [swaylock](https://github.com/swaywm/swaylock) \| [waylock](https://codeberg.org/ifreund/waylock) + [wleave](https://github.com/AMNatty/wleave) |
| 🧰 Configuration Tools | [swaysettings](https://github.com/ErikReider/SwaySettings) + [nwg-displays](https://github.com/nwg-piotr/nwg-displays) |
| 📺 Output Config Tools | [wlr-randr](https://gitlab.freedesktop.org/emersion/wlr-randr) \| [kanshi](https://sr.ht/~emersion/kanshi) \| [shikane](https://gitlab.com/w0lff/shikane) |

---

## 🧰 Utilities & System Tools

| Module Type | Module Name |
|-------------|-------------|
| 📊 Monitoring & Metrics  | [btop](https://github.com/aristocratos/btop) \| [glances](https://github.com/nicolargo/glances) \| [netdata](https://github.com/netdata/netdata) \| [nvtop](https://github.com/Syllo/nvtop) \| [s-tui](https://github.com/amanusk/s-tui) \| [neohtop](https://github.com/Abdenasser/neohtop) \| [mission-center](https://gitlab.com/mission-center-devs/mission-center) |
| 💻 System Utilities      | [iotop](https://github.com/Tomas-M/iotop) \| [kmon](https://github.com/orhun/kmon) \| [systemd-manager-tui](https://github.com/matheus-git/systemd-manager-tui) \| [powertop](https://github.com/fenrus75/powertop) \| [acpid](https://wiki.archlinux.org/title/Acpid) |
| 🧠 Info & Diagnostics    | [inxi](https://codeberg.org/smxi/inxi) \| [duf](https://github.com/muesli/duf) \| [wavemon](https://github.com/uoaerg/wavemon) \| [iftop](https://code.blinkace.com/pdw/iftop) |
| 📁 Disk & File Tools     | [dua-cli](https://github.com/Byron/dua-cli) \| [fselect](https://github.com/jhspetersson/fselect) \| [broot](https://github.com/Canop/broot) |
| 📚 Knowledge Tools       | [navi](https://github.com/denisidoro/navi) \| [xdg-ninja](https://github.com/b3nj5m1n/xdg-ninja) |
| 🧊 Misc                  | [wayfreeze](https://github.com/Jappie3/wayfreeze) \| [hyprfreeze](https://github.com/Zerodya/hyprfreeze) \| [vigiland](https://github.com/Jappie3/vigiland) \| [planify](https://github.com/alainm23/planify) \| [resources](https://github.com/nokyan/resources) \| [arch-update](https://github.com/Antiz96/arch-update) |
| 🔧 Misc. Tools           | [wluma](https://github.com/maximbaz/wluma) \| [laptop-mode-tools](https://github.com/rickysarraf/laptop-mode-tools) \| [thermald](https://github.com/intel/thermal_daemon) |
| 📦 Others                | [usql](https://github.com/xo/usql) \| [jq](https://jqlang.org/) \| [pik](https://github.com/jacek-kurlit/pik) \| [woomer](https://github.com/coffeeispower/woomer) |

---

## 📋 Clipboard, Notifications, Input

| Module Type | Module Name |
|-------------|-------------|
| 🗂️ Clipboard Manager   | [wl-clipboard-rs](https://github.com/YaLTeR/wl-clipboard-rs) \| [cliphist](https://github.com/sentriz/cliphist) \| [clipse](https://github.com/savedra1/clipse) \| [clipvault](https://github.com/rolv-apneseth/clipvault) |
| 🔠 Emoji Picker        | [bemoji](https://github.com/marty-oehme/bemoji)                             |

---

## 📦 Applications

| Module Type | Module Name |
|-------------|-------------|
| 🚀 App Launcher          | [fuzzel](https://codeberg.org/dnkl/fuzzel) \| [walker](https://github.com/abenz1267/walker) |
| 📁 File Managers         | [pcmanfm-qt](https://github.com/lxqt/pcmanfm-qt) \| [nautilus](https://wiki.gnome.org/Apps/Files) \| [yazi](https://github.com/sxyazi/yazi) |
| 📝 Text Editors          | [zed](https://github.com/zed-industries/zed) \| [vscode](https://wiki.archlinux.org/title/Visual_Studio_Code) \| [micro](https://github.com/zyedidia/micro) \| [orbiton](https://github.com/xyproto/orbiton) \| [nano](https://cgit.git.savannah.gnu.org/cgit/nano.git) |
| 📸 Screenshot Tools      | [wayshot](https://git.sr.ht/~shinyzenith/wayshot) \| [grimshot](https://github.com/OctopusET/sway-contrib) \| [shotman](https://git.sr.ht/~whynothugo/shotman) \| [satty](https://github.com/gabm/satty) |
| 🎥 Screen Recording      | [wl-screenrec](https://github.com/russelltg/wl-screenrec) \| [gpu-screen-recorder](https://git.dec05eba.com/gpu-screen-recorder/about/) \| [obs](https://obsproject.com/) |
| 🎵 Media Players         | [mpv](https://github.com/mpv-player/mpv) + [yt-dlp](https://github.com/yt-dlp/yt-dlp) |
| 🎧 Audio Tools           | [rmpc](https://github.com/mierak/rmpc) \| [ncspot](https://github.com/hrkfdn/ncspot) \| [playerctl](https://github.com/altdesktop/playerctl) + [pwvucontrol](https://github.com/saivert/pwvucontrol) \| [easyeffects](https://github.com/wwmm/easyeffects) |
| 📊 Audio Visualizer      | [cava](https://github.com/karlstav/cava) \| [musializer](https://github.com/tsoding/musializer) |
| 📖 PDF Reader            | [zathura](https://github.com/pwmt/zathura)                                  |
| 🖼️ Image Viewer          | [oculante](https://github.com/woelper/oculante)                             |
| ⏰ Clock                 | [tenki](https://github.com/ckaznable/tenki)                                 |
| 📈 System Fetch          | [fastfetch](https://github.com/fastfetch-cli/fastfetch)                     |
| 🌧️ Terminal Visuals      | [ascii-rain](https://github.com/nkleemann/ascii-rain)                       |
| 🗒️ Notes                 | [obsidian](https://obsidian.md/) \| [AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) + [notesnook](https://notesnook.com/) |
| 🔖 Bookmark Manager      | [raindrop](https://raindrop.io/)                                            |

---

## 🎨 Theming & Appearance

| Module Type | Module Name |
|-------------|-------------|
| 🎨 Theme Manager | [kvantum](https://github.com/tsujan/Kvantum) + [nwg-look](https://github.com/nwg-piotr/nwg-look) |
| 🌈 GTK Themes    | [libadwaita](https://gitlab.gnome.org/GNOME/libadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| ✨ Qt Themes     | [kvlibadwaita](https://github.com/GabePoel/KvLibadwaita) \| [nordic](https://github.com/EliverLara/Nordic) \| [whale](https://github.com/anufrievroman/whale) |
| 🧸 Icons         | [Papirus Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) |
| 🔤 Fonts         | [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) |

---
