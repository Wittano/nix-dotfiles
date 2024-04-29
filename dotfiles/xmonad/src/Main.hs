module Main (main) where

import Const qualified as C
import Keyboard qualified as K
import Layout qualified as L
import Startup qualified as S
import Workspace qualified as W
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Hacks (trayerPaddingXmobarEventHook, windowedFullscreenFixEventHook)
import Xmobar qualified as S

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobarrc" (pure S.bar)) defToggleStrutsKey $ myConfig

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
      handleEventHook = windowedFullscreenFixEventHook <> swallowEventHook (className =? "kitty") (return True) <> trayerPaddingXmobarEventHook
    }
    `additionalKeysP` K.keybinds
