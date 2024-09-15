
module Main (main) where

import Const qualified as C
import Keyboard qualified as K
import Layout qualified as L
import Startup qualified as S
import Workspace qualified as W
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Prelude
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Hacks (fixSteamFlicker, trayerPaddingXmobarEventHook, windowedFullscreenFixEventHook)
import Xmobar qualified as S

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh $ myConfig

myConfig =
  def
    { modMask = mod4Mask,
      layoutHook = L.layout,
      terminal = C.terminal,
      normalBorderColor = "#24273a",
      focusedBorderColor = "#8be9fd",
      borderWidth = 2,
      manageHook = W.rules,
      startupHook = S.hook,
      workspaces = W.desktopWorkspaces,
      handleEventHook = fixSteamFlicker <> windowedFullscreenFixEventHook <> swallowEventHook (className =? "kitty") (return True) <> trayerPaddingXmobarEventHook
    }
    `additionalKeysP` K.keybinds
