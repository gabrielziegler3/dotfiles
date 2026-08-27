-- Hyprland Lua configuration (replaces legacy hyprland.conf before Hyprland 0.57).

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("PATH", "/home/gabrielziegler/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin")

-- Monitors
hl.monitor({ output = "desc:Dell Inc. DELL U2725QE GPB1PF4", mode = "3840x2160@120", position = "0x0", scale = "1.6" })
hl.monitor({ output = "desc:AOC Q27G2SG4 PKIN4XA000532", mode = "2560x1440@155", position = "0x0", scale = "1" })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "1" })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.config({
    xwayland = { force_zero_scaling = true },
    input = {
        kb_layout = "us,us", kb_variant = ",intl",
        repeat_rate = 70, repeat_delay = 280,
        follow_mouse = 0, sensitivity = 0,
    },
    general = {
        gaps_in = 5, gaps_out = 8, border_size = 3,
        col = {
            active_border = { colors = { "rgba(7aa2f7ff)", "rgba(bb9af7ff)" }, angle = 45 },
            inactive_border = "rgba(1a1b2600)",
        },
        layout = "dwindle", resize_on_border = true, extend_border_grab_area = 15,
    },
    decoration = {
        rounding = 10, active_opacity = 0.95, inactive_opacity = 0.88,
        blur = { enabled = true, size = 6, passes = 3, xray = false, popups = true },
        shadow = { enabled = true, range = 5, offset = { 1, 1 }, render_power = 3, color = "rgba(00000099)" },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    group = {
        col = { border_active = "rgba(7aa2f7ff)", border_inactive = "rgba(565f8966)" },
        groupbar = { font_size = 11, col = { active = "rgba(7aa2f7ff)", inactive = "rgba(1a1b26ff)" } },
    },
    misc = { disable_hyprland_logo = true, disable_splash_rendering = true },
})

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.curve("ease", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "ease", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "ease", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "ease" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "ease", style = "fade" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "ease" })
hl.animation({ leaf = "borderangle", enabled = false })

local mod = "ALT"
local function bind(keys, action, opts) hl.bind(keys, action, opts) end
local function exec(command) return hl.dsp.exec_cmd(command) end

-- Launch and focus
bind(mod .. " + Return", exec("kitty"))
bind(mod .. " + d", exec("rofi -show drun -show-icons"))
bind(mod .. " + SHIFT + q", hl.dsp.window.close())
for _, key in ipairs({ { "h", "left" }, { "j", "down" }, { "k", "up" }, { "l", "right" }, { "Left", "left" }, { "Down", "down" }, { "Up", "up" }, { "Right", "right" } }) do
    bind(mod .. " + " .. key[1], hl.dsp.focus({ direction = key[2] }))
    bind(mod .. " + SHIFT + " .. key[1], hl.dsp.window.move({ direction = key[2] }))
end

-- Resize active windows
for _, key in ipairs({ { "h", 20, 0 }, { "j", 0, 20 }, { "k", 0, -20 }, { "l", -20, 0 }, { "Left", 20, 0 }, { "Down", 0, 20 }, { "Up", 0, -20 }, { "Right", -20, 0 } }) do
    bind(mod .. " + CTRL + " .. key[1], hl.dsp.window.resize({ x = key[2], y = key[3], relative = true }), { repeating = true })
end

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Layout and session
bind(mod .. " + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + ALT + f", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
bind(mod .. " + space", hl.dsp.window.cycle_next())
bind("SUPER + space", exec("hyprctl switchxkblayout all next"))
bind(mod .. " + e", hl.dsp.layout("togglesplit"))
bind(mod .. " + SHIFT + s", hl.dsp.window.pin({ action = "toggle" }))
bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
bind(mod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))
bind(mod .. " + SHIFT + c", exec("hyprctl reload"))
bind(mod .. " + SHIFT + e", exec("wlogout"))
bind(mod .. " + SHIFT + x", exec("hyprlock"))
bind(mod .. " + x", exec("systemctl suspend"))

-- Applications and screenshots
bind(mod .. " + b", exec("kitty -e yazi"))
bind(mod .. " + c", exec("kitty -e python3"))
bind(mod .. " + n", exec("~/.scripts/cycle-wallpaper.sh $HOME/Pictures/Wallpapers"))
bind(mod .. " + y", exec("wl-copy < ~/.scripts/linkedin_response.md"))
bind("SUPER + SHIFT + s", exec("grim - | /home/gabrielziegler/.local/bin/satty --filename - --fullscreen --initial-tool crop --output-filename ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png --early-exit --copy-command wl-copy"))
bind("Print", exec("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))
bind(mod .. " + Print", exec("grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))

-- Media, brightness, and mouse
bind("XF86AudioRaiseVolume", exec("pactl set-sink-volume @DEFAULT_SINK@ +3%"), { repeating = true })
bind("XF86AudioLowerVolume", exec("pactl set-sink-volume @DEFAULT_SINK@ -3%"), { repeating = true })
bind("XF86AudioMute", exec("amixer -q sset Master toggle"))
bind("XF86AudioPause", exec("playerctl --player=spotify play-pause"))
bind("XF86AudioPlay", exec("playerctl --player=spotify play-pause"))
bind("XF86AudioNext", exec("playerctl --player=spotify next"))
bind("XF86AudioPrev", exec("playerctl --player=spotify previous"))
bind("XF86MonBrightnessUp", exec("brightnessctl set +5%"), { repeating = true })
bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { repeating = true })
bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

bind(mod .. " + m", exec("pkill -SIGUSR1 waybar"))
bind(mod .. " + SHIFT + n", exec("swaync-client -t -sw"))
bind(mod .. " + v", exec("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
bind("SUPER + SHIFT + c", exec("hyprpicker -a"))
bind(mod .. " + t", hl.dsp.group.toggle())
bind(mod .. " + Tab", hl.dsp.group.next())

-- Window and layer rules
for _, class in ipairs({ "pavucontrol", "nemo", "Galculator", "Nitrogen", "Matplotlib", "easyeffects" }) do
    hl.window_rule({ match = { class = class }, float = true })
end
for _, title in ipairs({ "alsamixer", "File Transfer.*" }) do
    hl.window_rule({ match = { title = title }, float = true })
end
hl.window_rule({ match = { class = "wlogout" }, float = true })
hl.window_rule({ match = { class = "firefox|google-chrome|brave-browser|chromium" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "mpv|vlc|Spotify" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "eog|feh|gimp" }, opacity = "1.0 override" })
hl.window_rule({ match = { fullscreen = true }, opacity = "1.0 override" })
for _, namespace in ipairs({ "rofi", "waybar", "notifications" }) do
    hl.layer_rule({ match = { namespace = namespace }, blur = true })
    hl.layer_rule({ match = { namespace = namespace }, ignore_alpha = 0 })
end

-- exec-once equivalents
hl.on("hyprland.start", function()
    for _, command in ipairs({
        "~/.config/hypr/scripts/laptop-display.sh",
        "swaybg -i ~/Pictures/Wallpapers/primavera.jpg -m fill",
        "waybar", "swaync", "nm-applet", "blueman-applet",
        "easyeffects --gapplication-service", "~/.local/bin/ram-monitor.sh",
        "wl-paste --type text --watch cliphist store",
        "wl-paste --type image --watch cliphist store",
        "XDG_CURRENT_DESKTOP=sway flameshot", "kitty",
    }) do
        hl.dispatch(hl.dsp.exec_cmd(command))
    end
end)
