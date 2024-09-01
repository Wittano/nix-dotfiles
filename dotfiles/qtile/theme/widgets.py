import os
from typing import Dict

from libqtile import widget
from libqtile.command import lazy

from const import TERMINAL, DEFAULT_THEME_NAME


class LogoWidget(widget.TextBox):
    def __init__(self, theme: Dict[str, str]):
        super(LogoWidget, self).__init__(
            text='\uf157',
            fontsize=25,
            font="Hack Nerd Font",
            background=theme["background"],
            foreground=theme["foreground"],
            padding=20,
        )


class TitlebarWidget(widget.WindowName):
    def __init__(self, theme: Dict[str, str]):
        super().__init__(
            foreground=theme["green"],
            background=theme["brightness_background"],
            padding=10,
            max_chars=40,
        )


class GroupBoxWidget(widget.GroupBox):
    def __init__(self, theme: Dict[str, str]):
        super().__init__(
            highlight_method='line',
            borderwidth=3,
            fontsize=18,
            background=theme["background"],
            this_current_screen_border=theme["foreground"],
            block_highlight_text_color=theme["foreground"],
            active=theme["green"],
            padding_x=10,
            highlight_color = [ theme["brightness_background"], theme["current_line"] ],
            foreground=theme["brightness_background"],
            inactive=theme["current_line"],
            urgent_text=theme["comment"],
            urgent_border=theme["orange"],
            urgent_alert_method='block',
            invert_mouse_wheel=True,
            disable_drag=True,
        )


class MemoryWidget(widget.Memory):
    def __init__(self, theme: Dict[str, str]):
        super(MemoryWidget, self).__init__(
            format="\uf2db {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
            measure_mem="M",
            font="Hack NF Bold",
            background=theme["background"],
            foreground=theme["pink"],
        )


class ClockWidget(widget.Clock):
    defaults = [
        (
            "long_format",
            "  %d/%m/%y - %a, %I:%M %p",
            "Format to show when mouse is over widget."
        )
    ]

    def __init__(self, theme: Dict[str, str]):
        super().__init__(
            format='\uf017  %I:%M %p',
            font="Hack NF Bold",
            padding=30,
            foreground=theme["yellow"],
        )

        self.add_defaults(ClockWidget.defaults)
        self.short_format = self.format

    def mouse_enter(self, *args, **kwargs):
        self.format = self.long_format
        self.bar.draw()

    def mouse_leave(self, *args, **kwargs):
        self.format = self.short_format
        self.bar.draw()


class NetWidget(widget.Net):
    def __init__(self, theme: Dict[str, str]):
        super().__init__(
            interface="eno1",
            format="\uf063  {down:.1f}{down_suffix}  \uf062  {up:.1f}{up_suffix}",
            font="Hack NF Bold",
            background=theme["background"],
            foreground=theme["orange"]
        )


class CPUWidget(widget.CPU):
    def __init__(self, theme: Dict[str, str]):
        super(CPUWidget, self).__init__(
            background=theme["background"],
            foreground=theme["purple"],
            font="Hack NF Bold",
            format='  {load_percent}%',
            mouse_callbacks={
                'Button1': lazy.spawn(f"{TERMINAL} -e 'htop'")
            },
        )


class RoundedSeparator(widget.Image):
    def __init__(self, theme: Dict[str, str], isLeft: bool = True):
        direction = "left" if isLeft else "right"

        super(RoundedSeparator, self).__init__(
            filename=f"{os.getenv('HOME')}/.config/qtile/assets/{DEFAULT_THEME_NAME}/rounded_{direction}_sep.png",
            background=theme["brightness_background"],
        )


class CurveSeparator(widget.Image):
    def __init__(self, theme: Dict[str, str], isLeft: bool = True):
        homeDir = os.getenv("HOME")
        direction = "left" if isLeft else "right"

        super(CurveSeparator, self).__init__(
            filename=f"{homeDir}/.config/qtile/assets/{DEFAULT_THEME_NAME}/curve_{direction}_sep.png",
            background=theme["brightness_background"],
        )


class SepLineSeparator(widget.Image):
    def __init__(self, theme: Dict[str, str], isLeft: bool = True):
        homeDir = os.getenv("HOME")
        direction = "left" if isLeft else "right"

        super(SepLineSeparator, self).__init__(
            filename=f"{homeDir}/.config/qtile/assets/{DEFAULT_THEME_NAME}/sep_{direction}_line.png",
            background=theme["brightness_background"],
        )


class VolumeWidget(widget.Volume):
    def __init__(self, theme: Dict[str, str]):
        super(VolumeWidget, self).__init__(
            fmt='  {}',
            fontsize=14,
            font="Hack NF Bold",
            background=theme["background"],
            foreground=theme["red"],
        )


class SysTrayWidget(widget.Systray):
    def __init__(self, theme: Dict[str, str]):
        super(SysTrayWidget, self).__init__(
            background=theme["background"],
        )


class SearchWidget(widget.TextBox):
    def __init__(self, theme: Dict[str, str]):
        super(SearchWidget, self).__init__(
            text="\ue68f  Search",
            fontfamily="Font Awesome 6 Free-Solid",
            fontsize="16",
            margin=0,
            mouse_callbacks={
                "Button1": lazy.spawn("rofi -show drun")
            },
            background=theme["background"],
        )
