module Xmobar (bar) where

import XMonad
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers (logTitles)

bar :: PP
bar =
  def
    { ppSep = " ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap "[ " " ]" . xmobarBorder "" "#ea76cb" 0,
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

    blue = xmobarColor "#1e66f5" ""
    white = xmobarColor "#4c4f69" ""
    yellow = xmobarColor "#df8e1d" ""
    urgent = xmobarColor "#d20f39" ""
    green = xmobarColor "#40a02b" ""
    inactive = xmobarColor "#5b6078" ""
