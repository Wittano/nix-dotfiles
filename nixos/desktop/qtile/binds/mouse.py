from libqtile.config import Drag
from libqtile.lazy import lazy

from const import SUPER_KEY, CONTROL_KEY

RIGHT_BUTTON = "Button3"
MIDDLE_BUTTON = "Button2"
LEFT_BUTTON = "Button1"

MOUSE_BINDS = [
    Drag([SUPER_KEY], LEFT_BUTTON, lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([SUPER_KEY], RIGHT_BUTTON, lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
]
