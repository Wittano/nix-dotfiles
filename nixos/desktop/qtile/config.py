import os
import subprocess
from typing import List

from libqtile import hook
from libqtile.config import Screen

from binds import keyboard
from binds import mouse as CustomeMouseBinding
from groups import get_default_groups
from layout import layouts as CustomLayouts
from layout.floating import FLOATING_LAYOUT
from scripts import monitors
from theme.screen import MAIN_SCREEN

groups = get_default_groups()

keys = keyboard.get_keybindings(groups)

layouts = [CustomLayouts.MAX, CustomLayouts.MONAD_TALL]

widget_defaults = dict(
    font="jetbrains-mono",
    fontsize=14,
    padding=3,
)

extension_defaults = widget_defaults.copy()

# TODO Create better system to spawn screen configuration between Laptop and PC
screens = [MAIN_SCREEN] + ([Screen()] if monitors.get_monitors_count() > 1 else [])

mouse = CustomeMouseBinding.MOUSE_BINDS

dgroups_key_binder = None
dgroups_app_rules: List = []
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

floating_layout = FLOATING_LAYOUT

auto_fullscreen = True
focus_on_window_activation = "never"
reconfigure_screens = True
auto_minimize = False

wmname = "LG3D"


########
# Hooks
########


@hook.subscribe.startup_once
def autostart_hook():
    home_dir = os.environ["HOME"]
    autostart_path = f"{home_dir}/.config/autostart.sh"

    if os.path.isfile(autostart_path):
        subprocess.call([autostart_path])
