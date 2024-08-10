from libqtile import layout

from const import DEFAULT_THEME

__layout_theme = {
    "margin": 30,
    "border_width": 2,
    "border_focus": DEFAULT_THEME["selection"],
    "border_normal": DEFAULT_THEME["background"]
}

COLUMN = layout.Columns(
    border_on_single=True,
    border_normal_stack=__layout_theme["border_normal"],
    border_focus_stack=__layout_theme["border_focus"],
    **__layout_theme
)
MAX = layout.Max(margin=0)
STACK = layout.Stack(num_stacks=2)
BSPWM = layout.Bsp(**__layout_theme)
MATRIX = layout.Matrix()
MONAD_TALL = layout.MonadTall(
    change_ratio=0.2,
    **__layout_theme
)
MONAD_WIDE = layout.MonadWide(**__layout_theme)
RATIO_TILE = layout.RatioTile(**__layout_theme)
TILE = layout.Tile(**__layout_theme)
TREE_TAB = layout.TreeTab(
    panel_width=200,
    margin_y=10,
    active_bg=__layout_theme["border_focus"],
    inactive_bg=__layout_theme["border_normal"],
    **__layout_theme
),
VERTICAL_TILE = layout.VerticalTile(**__layout_theme)
ZOMMY = layout.Zoomy(**__layout_theme)
SPIRAL = layout.Spiral(
    ratio=0.6,
    new_client_position='after_current',
    **__layout_theme)
