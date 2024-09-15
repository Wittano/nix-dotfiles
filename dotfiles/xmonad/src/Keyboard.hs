module Keyboard (keybinds) where

import Const qualified as C
import Data.Maybe (fromJust)
import Workspace qualified as W
import XMonad (ChangeLayout (NextLayout), ScreenId, X, screenWorkspace, sendMessage, spawn, windows, withWindowSet)
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.OnScreen qualified as W
import XMonad.Hooks.ManageDocks (ToggleStruts (ToggleStruts))
import XMonad.Layout.MultiToggle qualified as MT
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.Layout.ToggleLayouts qualified as T
import XMonad.StackSet qualified as W
import XMonad.Util.Ungrab (unGrab)

flipScreen :: ScreenId -> ScreenId
flipScreen 1 = 0
flipScreen 0 = 1
flipScreen sid = sid - 1

customKeybinds :: [(String, X ())]
customKeybinds =
  [ ("M-e", spawn "rofi -show drun"),
    ("M-w", spawn "rofi -show window"),
    ("M-S-p", unGrab *> spawn "flameshot gui"),
    ("M-S-q", spawn "switch-off"),
    ("M-n", spawn "time-notify"),
    ("M-p", unGrab *> spawn "amixer sset Master 5%+"),
    ("M-o", unGrab *> spawn "amixer sset Master 5%-"),
    ("M-m", unGrab *> spawn "amixer sset Master toggle"),
    ("M-r", unGrab *> spawn "rollWallpaper"),
    ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
  ]

-- TODO replace remapKeys by rempaKeysP after upgrade xmonad to 0.18.0 version
remapKeys :: [(String, X ())]
remapKeys =
  [ ("M-<Return>", spawn C.terminal),
    ("M-<Tab>", sendMessage NextLayout),
    ("M-q", kill1),
    ("M-s", sendMessage $ T.Toggle "floats"),
    ("M-C-r", spawn "xmonad --restart"),
    ( "M-<Space>",
      do
        sid <- withWindowSet $ return . W.screen . W.current
        mirrorWorkspace <- screenWorkspace (flipScreen sid)
        windows $ W.greedyView $ fromJust mirrorWorkspace
    )
  ]

mkMoveWorkspace :: [(String, X ())]
mkMoveWorkspace = switchBinds ++ switchOnSecondScreen ++ moveWindow
  where
    rawKeybinds = [1 .. 10]
    calculWorkspaceId i = (i - 1) `mod` 5

    mkChangeWorkspaceBind :: Bool -> String -> (Int -> (String, X ()))
    mkChangeWorkspaceBind isPrimary keybindPrefix i =
      let workspaceId = calculWorkspaceId i
          action = if isPrimary then W.greedyView else W.greedyViewOnScreen (1 :: ScreenId)
       in (keybindPrefix ++ "-" ++ show (i `mod` 10), windows $ action (W.desktopWorkspaces !! workspaceId))

    switchBinds = map (mkChangeWorkspaceBind True "M") rawKeybinds
    switchOnSecondScreen = map (mkChangeWorkspaceBind False "M-C") rawKeybinds
    moveWindow =
      map
        ( \i ->
            ( "M-S-" ++ show (i `mod` 10),
              let workspaceId = W.desktopWorkspaces !! calculWorkspaceId i
               in windows $ W.greedyView workspaceId . W.shift workspaceId
            )
        )
        rawKeybinds

keybinds :: [(String, X ())]
keybinds = customKeybinds ++ mkMoveWorkspace ++ remapKeys
