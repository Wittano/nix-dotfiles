import re
from itertools import chain
from typing import List, Tuple, Union

from libqtile.log_utils import logger
from libqtile.config import Group, Match

_default_groups = [
    Group(name="1", label="\uebb4", layout="max"),
    Group(name="2", label="\uebb4", layout="max"),
    Group(name="3", label="\uebb4", layout="max"),
    Group(name="4", label="\uebb4", layout="max"),
    Group(name="5", label="\uebb4", layout="max"),
]

dev_group, www_group, sys_group, doc_group, chat_group = _default_groups


class _WindowMatch:
    def __init__(self, group: Union[str, int], match_rule: Match):
        self.group = group
        self.match_rule = match_rule


games_staff: List[str] = [
    "lutris",
    "Shogun2",
    "openttd",
    "factorio",
    "Stardew Valley",
    "Castle Story",
    "The Honkers Railway Launcher",
    "PrismLauncher",
    r"War Thunder*",
    r".x86_64",
    r".amd64",
    r".exe",
    r".x64",
    r"[Ll]inux$",
    r"steam_app*",
    r"[Ss]team*",
    r"[Mm]ono",
    r"[Mm]inecraft*",
]

_web_browsers: List[str] = [
    "Chromium",
    "qutebrowser",
    r"[fF]irefox*",
    r"[Nn]avigator",
    r"[tT]or*",
    r"Vivaldi-*",
]

_dev_staff: List[str] = [
    "Emacs",
    "Code",
    "jetbrains-*",
    "code-oss",
    r"(vsc)|(VSC)odium",
]

_terminals: List[str] = ["kitty", r"[tT]erminator"]

_science_staff: List[str] = ["Boincmgr", "Virt-manager", "VirtualBox Manager"]

_music_staff: List[str] = [
    "Qmmp",
    "player",
    "Rhythmbox",
    r"[sS]potify*",
]

_chat_staff: List[str] = ["discord", r"[sS]ignal*", r"[eE]lement", "telegram-desktop"]

_doc_staff: List[str] = ["obsidian", "Evince", r"[eE]og", r"[jJ]oplin"]

_matches: List[_WindowMatch] = [
    _WindowMatch(group="4", match_rule=Match(wm_class=re.compile(r"[tT]hunderbird"))),
    _WindowMatch(group="4", match_rule=Match(wm_class=re.compile("[kK]rita*"))),

    _WindowMatch(group="3", match_rule=Match(wm_class="Org.gnome.Nautilus")),
    _WindowMatch(group="3", match_rule=Match(wm_class=r"[nN]emo")),
    _WindowMatch(group="3", match_rule=Match(wm_class="FreeTube")),
    _WindowMatch(group="3", match_rule=Match(wm_class="streamlink-twitch-gui")),
    _WindowMatch(group="3", match_rule=Match(wm_class=r"(gl)|(mpv)")),

    _WindowMatch(group="1", match_rule=Match(wm_class="Postman")),
]


def get_default_groups() -> List[Group]:
    for group in _default_groups:
        group.matches = _get_matches_list(group.name)

    return _default_groups


def _get_wm_name(wm_name: str) -> Union[str, re.Pattern]:
    """
    Get Window name or Window name regex

    :param wm_name:
    :return:
    """
    try:
        return re.compile(wm_name)
    except re.error as err:
        logger.error(f"Failed compile regex '{wm_name}', cause: {err}")
        return wm_name


def _map_wm_names(group: Group, wm_names_list: List[str]):
    return map(
        lambda wm_name: _WindowMatch(
            group=group.name, match_rule=Match(wm_class=_get_wm_name(wm_name))
        ),
        wm_names_list,
    )


def _get_windows_matches() -> List[_WindowMatch]:
    """
    Create list of _WindowMatch object. WindowMatch object include group id and Match,
    that will be used to
    :return:
    """
    _group_matches: List[Tuple[Group, List[str]]] = [
        (dev_group, _dev_staff),
        (www_group, _web_browsers),
        (sys_group, _terminals),
        (chat_group, games_staff),
        (sys_group, _science_staff),
        (doc_group, _music_staff),
        (doc_group, _doc_staff),
        (chat_group, _chat_staff),
    ]

    window_matches_list = map(
        lambda group_match: _map_wm_names(group_match[0], group_match[1]),
        _group_matches,
    )
    flatten_group_matches: List[_WindowMatch] = list(chain(*window_matches_list))

    return _matches + flatten_group_matches


def _get_matches_list(group_name: str) -> List[Match]:
    windows_matches_list: List[_WindowMatch] = _get_windows_matches()
    filtered_windows_matches_list: filter[_WindowMatch] = filter(
        lambda window_match: window_match.group == group_name, windows_matches_list
    )

    return list(
        map(lambda window_match: window_match.match_rule, filtered_windows_matches_list)
    )
