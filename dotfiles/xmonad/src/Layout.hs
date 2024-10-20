module Layout (layout) where

import XMonad
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.SimplestFloat (simplestFloat)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.ToggleLayouts (toggleLayouts)
import XMonad.Layout.WindowArranger (windowArrange)

layout = maxLayout ||| tall ||| Mirror tall
  where
    tall =
      toggleLayouts floats $
        windowArrange $
          avoidStruts $
            limitWindows 4 $
              spacing 20 $
                -- magnifiercz 1.5 $
                Tall nmaster delta ratio
    maxLayout = noBorders Full
    floats = renamed [Replace "floats"] $ smartBorders simplestFloat
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100
