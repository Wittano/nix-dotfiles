import os.path
from typing import Optional

from libqtile.utils import guess_terminal

from theme import color


def get_theme_assets_path(theme: str | None) -> Optional[str]:
    path = f"{os.environ['HOME']}/.config/qtile/assets/{theme}"
    if not os.path.exists(path):
        return None

    return path

THEME_NAME = os.environ.get("QTILE_THEME")

if get_theme_assets_path(THEME_NAME) is None:
    THEME_NAME = "catppuccin_macchiato"

assert THEME_NAME is not None

SUPER_KEY = "mod4"
ALT_KEY = "mod1"
SHIFT_KEY = "shift"
CONTROL_KEY = "control"
DEFAULT_THEME = color.get_theme(THEME_NAME)
VOLUME_PERCENT_RATIO = 5
WEB_BROWSER = "vivaldi-stable"
TERMINAL = guess_terminal()

theme_path = get_theme_assets_path(THEME_NAME)
if theme_path is None or not os.path.exists(theme_path):
    raise FileNotFoundError(f"Missing directory for asserts: {theme_path}")
