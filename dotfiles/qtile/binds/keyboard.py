from typing import List

from libqtile.config import Key, Group
from libqtile.lazy import lazy

from const import SUPER_KEY, SHIFT_KEY, ALT_KEY, CONTROL_KEY, TERMINAL, VOLUME_PERCENT_RATIO
from scripts import monitors


def get_keybindings(groups: List[Group]) -> List[Key]:
    binds = [
        Key([SUPER_KEY], "h", lazy.layout.left(), desc="Move focus to left"),

        Key([SUPER_KEY], "l", lazy.layout.right(), desc="Move focus to right"),

        Key([SUPER_KEY], "j", lazy.layout.down(), desc="Move focus down"),

        Key([SUPER_KEY], "k", lazy.layout.up(), desc="Move focus up"),

        Key([SUPER_KEY, SHIFT_KEY], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([SUPER_KEY, SHIFT_KEY], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([SUPER_KEY, SHIFT_KEY], "j", lazy.layout.shuffle_down(), desc="Move window down"),
        Key([SUPER_KEY, SHIFT_KEY], "k", lazy.layout.shuffle_up(), desc="Move window up"),

        Key([SUPER_KEY], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),

        Key([SUPER_KEY], "Tab", lazy.next_layout(), desc="Toggle between layout"),

        Key([SUPER_KEY], "q", lazy.window.kill(), desc="Kill focused window"),

        Key([SUPER_KEY, ALT_KEY], "r", lazy.reload_config(), desc="Reload the config"),

        Key([SUPER_KEY, ALT_KEY], "q", lazy.shutdown(), desc="Shutdown Qtile"),

        Key([SUPER_KEY], "f", lazy.window.toggle_fullscreen(),
            desc="Put the focused window to/from fullscreen mode"),

        Key([SUPER_KEY], "s", lazy.window.toggle_floating(),
            desc="Put the focused window to/from floating mode"),

        Key([SUPER_KEY, SHIFT_KEY], "p", lazy.spawn("flameshot gui"),
            desc="Make screenshot"),

        Key([SUPER_KEY], "e", lazy.spawn("rofi -show drun"),
            desc="Run rofi in dmenu mode"),

        Key([SUPER_KEY], "w", lazy.spawn("rofi -show window"),
            desc="""
                    Run rofi in window mode - special mode, 
                    that show every opened applications on each workspaces
                """),

        Key([SUPER_KEY], "m", lazy.spawn("amixer sset Master toggle"),
            desc="Toggle mute/unmute volume"),

        Key([SUPER_KEY], "p", lazy.spawn(f"amixer sset Master {VOLUME_PERCENT_RATIO}%+"),
            desc="Increases volume"),

        Key([SUPER_KEY], "o", lazy.spawn(f"amixer sset Master {VOLUME_PERCENT_RATIO}%-"),
            desc="Decreases volume"),

        Key([SUPER_KEY], "space", monitors.swap_monitor,
            desc="Toggle focused window between monitors"),

        Key([SUPER_KEY], "n", lazy.next_screen(),
            desc="Toggle focused screen"),

        Key([SUPER_KEY, SHIFT_KEY], "q", lazy.spawn("switch-off"),
            desc="Shutdown Linux"),
        
        Key([SUPER_KEY], "r", lazy.spawn("rollWallpaper"),
            desc="Change wallpaper using rollWallpaper script"),
    ]

    for group in groups:
        additional_group_name = str((int(group.name) + 5) % 10)

        binds.extend([
            Key([SUPER_KEY], group.name, lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}"),

            Key([SUPER_KEY, SHIFT_KEY], group.name, lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {group.name}"),

            Key([SUPER_KEY, CONTROL_KEY], group.name, lazy.group[group.name].toscreen(1)),

            Key([SUPER_KEY], additional_group_name, lazy.group[group.name].toscreen(),
                desc=f"Switch to group {additional_group_name}"),

            Key([SUPER_KEY, SHIFT_KEY], additional_group_name, lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {additional_group_name}"),

            Key([SUPER_KEY, CONTROL_KEY], additional_group_name, lazy.group[group.name].toscreen(1))
        ])

    return binds
