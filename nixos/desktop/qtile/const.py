import os.path

from libqtile.utils import guess_terminal

from theme import color

SUPER_KEY = "mod4"
ALT_KEY = "mod1"
SHIFT_KEY = "shift"
CONTROL_KEY = "control"
DEFAULT_THEME_NAME = "catppuccin_macchiato"
DEFAULT_THEME = color.get_theme(DEFAULT_THEME_NAME)
VOLUME_PERCENT_RATIO = 5
WEB_BROWSER = "vivaldi-stable"
TERMINAL = guess_terminal()

asserts_dir_path = f"{os.environ['HOME']}/.config/qtile/assets/{DEFAULT_THEME_NAME}"
if not os.path.exists(asserts_dir_path):
    raise FileNotFoundError(f"Missing directory for asserts: {asserts_dir_path}")