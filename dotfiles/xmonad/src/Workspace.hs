module Workspace (desktopWorkspaces, rules) where

import XMonad
import XMonad.Hooks.ManageDocks (manageDocks)
import XMonad.Hooks.ManageHelpers (doFullFloat, doSink, isFullscreen)
import XMonad.Prelude (Endo)
import XMonad.Util.WindowPropertiesRE

desktopWorkspaces :: [String]
desktopWorkspaces = ["I", "II", "III", "IV", "V"]

-- TODO export creating rules for apps to external module
gamesStaff :: [String]
gamesStaff =
  [ "lutris",
    "Shogun2",
    "openttd",
    "factorio",
    "Stardew Valley",
    "Castle Story",
    "The Honkers Railway Launcher",
    "PrismLauncher",
    "^([a-zA-Z0-9_]+).x86_64$",
    "^([a-zA-Z0-9_]+).amd64$",
    "^([a-zA-Z0-9_]+).exe$",
    "^([a-zA-Z0-9_]+).x64$",
    "[Ll]inux$",
    "steam_app*",
    "[Ss]team*",
    "[Mm]ono",
    "[Mm]inecraft*"
  ]

webBrowsers :: [String]
webBrowsers =
  [ "Chromium",
    "^[fF]irefox*",
    "^[tT]or*",
    "^Vivaldi-*"
  ]

devStaff :: [String]
devStaff =
  [ "Emacs",
    "^jetbrains-*",
    "^([cC]ode)|(-oss)",
    "(vsc)|(VSC)odium"
  ]

terminals :: [String]
terminals =
  [ "kitty",
    "[aA]lacrity"
  ]

musicStaff :: [String]
musicStaff = ["^[sS]potify*"]

freeTubeRegex :: String
freeTubeRegex = "[Ff](ree)[Tt](ube)"

chatStaff :: [String]
chatStaff =
  [ "[dD]iscord",
    "^[sS]ignal*",
    "[eE]lement",
    "[Tt]elegram[dD]esktop",
    freeTubeRegex,
    "streamlink-twitch-gui"
  ]

docStaff :: [String]
docStaff = ["Evince", "[eE]og", "[jJ]oplin"]

mkWindowWorkspaceRule :: Int -> ([String] -> [Query (Endo WindowSet)])
mkWindowWorkspaceRule workspaceID = map mkShift
  where
    workspace = desktopWorkspaces !! workspaceIndex workspaceID
    mkShift appRegex
      | any (`elem` regexChars) appRegex = className ~? appRegex --> doShift workspace
      | otherwise = className =? appRegex --> doShift workspace
      where
        regexChars = "[]^${}"

    workspaceIndex :: Int -> Int
    workspaceIndex 0 = 0
    workspaceIndex i
      | i >= workspacesCount = workspacesCount - 1
      | i < 0 = 0
      | otherwise = i - 1
      where
        workspacesCount = length desktopWorkspaces

rules :: ManageHook
rules = composeAll $ shiftRules ++ stateRules
  where
    stateRules =
      [ manageDocks,
        isFullscreen --> doFullFloat,
        className =? "confirm" --> doFloat,
        className =? "file_progress" --> doFloat,
        className =? "dialog" --> doFloat,
        className =? "download" --> doFloat,
        className =? "error" --> doFloat,
        className =? "Gimp" --> doFloat,
        className =? "notification" --> doFloat,
        className =? "pinentry-gtk-2" --> doFloat,
        className =? "splash" --> doFloat,
        className =? "toolbar" --> doFloat,
        className ~? freeTubeRegex --> doSink
      ]
    shiftRules =
      mkWindowWorkspaceRule 5 gamesStaff
        ++ mkWindowWorkspaceRule 5 chatStaff
        ++ mkWindowWorkspaceRule 2 webBrowsers
        ++ mkWindowWorkspaceRule 1 devStaff
        ++ mkWindowWorkspaceRule 3 terminals
        ++ mkWindowWorkspaceRule 4 musicStaff
        ++ mkWindowWorkspaceRule 4 docStaff
