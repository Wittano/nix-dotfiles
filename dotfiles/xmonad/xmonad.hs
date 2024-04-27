import Data.Maybe (fromJust)
import XMonad
import XMonad qualified as W
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWindows qualified as W
import XMonad.Actions.OnScreen qualified as W
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (ToggleStruts (ToggleStruts), avoidStruts, manageDocks)
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle qualified as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.SimplestFloat (simplestFloat)
import XMonad.Layout.Spacing (spacing, spacingRaw)
import XMonad.Layout.ToggleLayouts qualified as T
import XMonad.Layout.WindowArranger (windowArrange)
import XMonad.StackSet (Screen (workspace))
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Hacks (trayerPaddingXmobarEventHook, windowedFullscreenFixEventHook)
import XMonad.Util.Loggers (logTitles)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Ungrab (unGrab)
import XMonad.Util.WindowPropertiesRE

-- TODO Replace xmobar by polybar or tint2
main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey $ myConfig

myWorkspaces :: [String]
myWorkspaces = ["I", "II", "III", "IV", "V"]

currentScreen = withWindowSet $ return . W.screen . W.current

additionalChangeWorkspaceKeybinds :: [(String, X ())]
additionalChangeWorkspaceKeybinds = switchWorkspace ++ switchWorkspaceOnSecondScreen ++ moveWindowToWorkspace
  where
    keybinds = [1 .. 10]
    calculWorkspaceId i = (i - 1) `mod` 5

    mkChangeWorkspaceKeybind :: Bool -> String -> (Int -> (String, X ()))
    mkChangeWorkspaceKeybind isPrimary keybindPrefix i =
      let workspaceId = calculWorkspaceId i
          action = if isPrimary then W.greedyView else W.greedyViewOnScreen (1 :: ScreenId)
       in (keybindPrefix ++ "-" ++ show (i `mod` 10), windows $ action (myWorkspaces !! workspaceId))
    switchWorkspace = map (mkChangeWorkspaceKeybind True "M") keybinds
    switchWorkspaceOnSecondScreen = map (mkChangeWorkspaceKeybind False "M-C") keybinds
    moveWindowToWorkspace =
      map
        ( \i ->
            ( "M-S-" ++ show (i `mod` 10),
              let workspaceId = myWorkspaces !! calculWorkspaceId i
               in windows $ W.greedyView workspaceId . W.shift workspaceId
            )
        )
        keybinds

-- TODO replace remapKeys by rempaKeysP after upgrade xmonad to 0.18.0 version
remapKeys :: [(String, X ())]
remapKeys =
  [ ("M-<Return>", spawn myTerminal),
    ("M-<Tab>", sendMessage NextLayout),
    ("M-q", kill1),
    ("M-s", sendMessage (T.Toggle "floats")),
    ("M-C-r", spawn "xmonad --restart"),
    ( "M-<Space>",
      do
        sid <- currentScreen
        mirrorWorkspace <- let screenId = if sid == 1 then 0 else 1 in screenWorkspace screenId
        windows $ W.greedyView $ fromJust mirrorWorkspace
    )
  ]

-- TODO autodetect terminal
myTerminal :: String
myTerminal = "kitty"

myConfig =
  def
    { modMask = mod4Mask,
      layoutHook = myLayout,
      terminal = myTerminal,
      normalBorderColor = "#24273a",
      focusedBorderColor = "#8be9fd",
      borderWidth = 2,
      manageHook = myManageHook,
      startupHook = myStartupHook,
      workspaces = myWorkspaces,
      handleEventHook = windowedFullscreenFixEventHook <> swallowEventHook (className =? "kitty") (return True) <> trayerPaddingXmobarEventHook
    }
    `additionalKeysP` ( [ ("M-e", spawn "rofi -show drun"),
                          ("M-w", spawn "rofi -show window"),
                          ("M-S-p", unGrab *> spawn "flameshot gui"),
                          ("M-S-q", spawn "switch-off"),
                          ("M-p", unGrab *> spawn "amixer sset Master 5%+"),
                          ("M-o", unGrab *> spawn "amixer sset Master 5%-"),
                          ("M-m", unGrab *> spawn "amixer sset Master toggle"),
                          ("M-r", unGrab *> spawn "rollWallpaper"),
                          ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
                        ]
                          ++ additionalChangeWorkspaceKeybinds
                          ++ remapKeys
                      )

-- TODO export creating rules for apps to external module
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

webBrowsers =
  [ "Chromium",
    "^[fF]irefox*",
    "^[tT]or*",
    "^Vivaldi-*"
  ]

devStaff =
  [ "Emacs",
    "^jetbrains-*",
    "^([cC]ode)|(-oss)",
    "(vsc)|(VSC)odium"
  ]

terminals =
  [ "kitty",
    "[aA]lacrity"
  ]

musicStaff = ["^[sS]potify*"]

freeTubeRegex = "[Ff](ree)[Tt](ube)"

chatStaff =
  [ "[dD]iscord",
    "^[sS]ignal*",
    "[eE]lement",
    "[Tt]elegram[dD]esktop",
    freeTubeRegex,
    "streamlink-twitch-gui"
  ]

docStaff = ["Evince", "[eE]og", "[jJ]oplin"]

mkShiftWindowToWorkspace id = map mkShift
  where
    workspace = myWorkspaces !! workspaceIndex id
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
        workspacesCount = length myWorkspaces

myManageHook = composeGeneral <+> workspaceFixedApps
  where
    -- TODO Read apps workspace posiotion from file generated by NixOS
    workspaceFixedApps :: ManageHook
    workspaceFixedApps =
      composeAll $
        mkShiftWindowToWorkspace 5 gamesStaff
          ++ mkShiftWindowToWorkspace 5 chatStaff
          ++ mkShiftWindowToWorkspace 2 webBrowsers
          ++ mkShiftWindowToWorkspace 1 devStaff
          ++ mkShiftWindowToWorkspace 3 terminals
          ++ mkShiftWindowToWorkspace 4 musicStaff
          ++ mkShiftWindowToWorkspace 4 docStaff
    composeGeneral =
      composeAll
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
          className ~? freeTubeRegex --> doFloat
        ]

-- TODO Migrate to xmonad logger
myStartupHook = spawnOnce "bash ~/.config/autostart.sh"

myLayout = tall ||| Mirror tall ||| max
  where
    tall =
      T.toggleLayouts floats $
        windowArrange $
          avoidStruts $
            limitWindows 4 $
              spacing 20 $
                magnifiercz' 1.5 $
                  Tall nmaster delta ratio
    max = noBorders Full
    floats = renamed [Replace "floats"] $ smartBorders simplestFloat
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

myXmobarPP :: PP
myXmobarPP =
  def
    { ppSep = " ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap "[ " " ]" . xmobarBorder "" "#a5adcb" 0,
      ppHidden = white . wrap " " "",
      ppHiddenNoWindows = inactive . wrap " " "",
      ppUrgent = urgent . wrap (yellow "!") (yellow "!"),
      ppOrder = \[ws, l, _, wins] -> ["   ", ws, " | ", wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = green . ppWindow
    formatUnfocused = blue . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue = xmobarColor "#8be9fd" ""
    white = xmobarColor "#cad3f5" ""
    yellow = xmobarColor "#eed49f" ""
    urgent = xmobarColor "#ed8796" ""
    green = xmobarColor "#a6da95" ""
    inactive = xmobarColor "#5b6078" ""
