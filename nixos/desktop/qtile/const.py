from libqtile.utils import guess_terminal

from theme import color

SUPER_KEY = "mod4"
ALT_KEY = "mod1"
SHIFT_KEY = "shift"
CONTROL_KEY = "control"
DEFAULT_THEME_NAME = "catppuccin_latte"
DEFAULT_THEME = color.get_theme(DEFAULT_THEME_NAME)
VOLUME_PERCENT_RATIO = 5
WEB_BROWSER = "vivaldi-stable"
TERMINAL = guess_terminal()
