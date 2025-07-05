module Xmobar (bar) where

import XMonad
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers (logTitles)

bar :: PP
bar =
  def
    { ppSep = " ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap "[ " " ]" . xmobarBorder "" "#a5adcb" 0,
      ppHidden = white . wrap " " "",
      ppHiddenNoWindows = inactive . wrap " " "",
      ppUrgent = urgent . wrap (yellow "!") (yellow "!"),
      ppOrder = \[ws, _, _, wins] -> ["   ", ws, " | ", wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = green . ppWindow
    formatUnfocused = blue . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue = xmobarColor "#b7bdf8" ""
    white = xmobarColor "#5b6078" ""
    yellow = xmobarColor "#df8e1d" ""
    urgent = xmobarColor "#ed8796" ""
    green = xmobarColor "#a6da95" ""
    inactive = xmobarColor "#292c3c" ""
