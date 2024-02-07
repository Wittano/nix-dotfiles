import os
import subprocess
from typing import List, Optional

import libqtile.log_utils
from libqtile.command import lazy
from libqtile.core.manager import Qtile

WACOM_SCRIPT_PATH: str = f"{os.environ['HOME']}/projects/config/system/scripts/wacom-multi-monitor.sh"


def _map_to_output(selected_monitor: str) -> bytes:
    return subprocess.Popen([
        "bash",
        WACOM_SCRIPT_PATH,
        selected_monitor
    ], stderr=subprocess.PIPE).stderr.read()


def map_wacom_to_one_monitor(screen_index: int):
    monitors = _get_monitors_name()
    error = _map_to_output(monitors[screen_index])

    if error:
        new_monitors = [f"HEAD-{i}" for i in range(len(monitors))]

        error = _map_to_output(new_monitors[screen_index])

        if error:
            libqtile.log_utils.logger.warning(
                f"Script {WACOM_SCRIPT_PATH} was ended failure by cause: {bytes.decode(error)}")


def _get_monitors_name() -> Optional[List[str]]:
    def get_monitor(x: str) -> str:
        return x.split(" ")[-1]

    monitors_output, error = subprocess.Popen(['xrandr', '--listactivemonitors'], stdout=subprocess.PIPE).communicate()
    monitors_list = bytes.decode(monitors_output).split("\n")[1:]

    if error:
        libqtile.log_utils.logger.warning(f"Getting monitor failed: {error}")
        return None

    return [monitor for monitor in map(get_monitor, monitors_list) if monitor]


def get_monitors_count() -> int:
    """
    Get number of active and connected monitors

    :return:
        Number of monitors
    """
    try:
        monitors: list[str] = subprocess.check_output(
            args='xrandr --query | grep " connected"',
            shell=True
        ).decode().split('\n')

        return len(list(filter(lambda x: x.strip() != '', monitors)))
    except Exception as error:
        libqtile.log_utils.logger.warning(error)
        return 1


_MONITORS_COUNT = get_monitors_count()


@lazy.function
def swap_monitor(qtile: Qtile):
    current_group = qtile.current_group
    current_screen_index = qtile.current_screen.index
    selected_screen = current_screen_index + 1 if current_screen_index + 1 < _MONITORS_COUNT else 0

    qtile.groups_map[current_group.name].cmd_toscreen(selected_screen)
