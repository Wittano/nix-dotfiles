import re

from libqtile import layout
from libqtile.config import Match

from const import DEFAULT_THEME

FLOATING_LAYOUT = layout.Floating(
    border_focus=DEFAULT_THEME["cyan"],
    border_normal=DEFAULT_THEME["background"],
    border_width=2,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='ssh-askpass'),
        Match(title='branchdialog'),
        Match(wm_class=re.compile('[pP]inentry*')),
    ]
)