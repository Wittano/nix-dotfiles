from libqtile import bar
from libqtile.config import Screen
from libqtile.widget.spacer import Spacer

from const import DEFAULT_THEME
from theme.widgets import GroupBoxWidget, ClockWidget, LogoWidget, TitlebarWidget, MemoryWidget, \
    VolumeWidget, CurveSeparator, SepLineSeparator, RoundedSeparator, SysTrayWidget, SearchWidget, NetWidget

theme = DEFAULT_THEME
SPACER = Spacer(length=10, background=theme["brightness_background"])
BLACK_SPACER = Spacer(length=10, background=theme["background"])

PRIMARY_SCREEN = Screen(
    top=bar.Bar([
        LogoWidget(theme),
        CurveSeparator(theme, isLeft=False),
        SPACER,
        GroupBoxWidget(theme),
        SPACER,
        CurveSeparator(theme),
        BLACK_SPACER,
        SearchWidget(theme),
        RoundedSeparator(theme, isLeft=False),
        TitlebarWidget(theme),
        RoundedSeparator(theme),
        SysTrayWidget(theme),
        CurveSeparator(theme, isLeft=False),
        SPACER,
        VolumeWidget(theme),
        SPACER,
        SepLineSeparator(theme),
        SPACER,
        NetWidget(theme),
        SPACER,
        SepLineSeparator(theme),
        SPACER,
        MemoryWidget(theme),
        SPACER,
        CurveSeparator(theme),
        ClockWidget(theme),
    ],
        size=32,
        background=theme["background"],
        border_color=theme["background"],
        margin=[15, 60, 6, 60])
)
