import os
import re
import subprocess
from typing import List

import libqtile.hook
from libqtile import hook
from libqtile.backend.base import Window
from libqtile.config import Group, Key, Screen
from libqtile.core.manager import Qtile
from libqtile.log_utils import logger

import groups
from groups import games_staff
from binds import keyboard, mouse
from const import DEFAULT_THEME
from layout.floating import FLOATING_LAYOUT
from layout.layouts import LayoutsCollection
from scripts import monitors
from theme.screen import PRIMARY_SCREEN

QTILE: Qtile = libqtile.qtile

groups: List[Group] = groups.get_default_groups()
keys: List[Key] = keyboard.get_keybindings(groups)
layout_collection = LayoutsCollection(DEFAULT_THEME)

layouts = [
    layout_collection.max_layout,
    layout_collection.monad_tall_layout
]

widget_defaults = dict(
    font='jetbrains-mono',
    fontsize=14,
    padding=3,
)

extension_defaults = widget_defaults.copy()

screens = [PRIMARY_SCREEN] + [Screen()] if monitors.get_monitors_count() > 1 else []

mouse = mouse.MOUSE_BINDS

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
    home_dir = os.environ['HOME']
    autostartPath = f"{home_dir}/.config/autostart.sh"

    if os.path.isfile(autostartPath):
        subprocess.call([autostartPath])


@hook.subscribe.client_new
async def move_non_games_from_game_workspace(_: Window):
    games_regex: List[re.Pattern] = []

    for rex in games_regex:
        try:
            games_regex.append(re.compile(rex))
        except re.error as err:
            libqtile.log_utils.logger.error(f"Failed compile regex '{rex}', cause: {err}")

    windows: List[Window] = list(
        filter(lambda window: True not in [bool(x.search(window.get_wm_class()[0])) for x in games_regex],
               QTILE.groups_map["5"].windows))

    if len(windows) == len(QTILE.groups_map["5"].windows):
        libqtile.log_utils.logger.warning("No found any non-game window on gaming workspace")
        return

    for win in windows:
        if len(QTILE.screens) > 1:
            screen_index = 0 if QTILE.current_screen.index == 1 else 1

            win.togroup(QTILE.screens[screen_index].group.name)
