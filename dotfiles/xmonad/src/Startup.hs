module Startup (hook) where

import XMonad (X)
import XMonad.Util.SpawnOnce (spawnOnce)

-- TODO Migrate to xmonad logger
hook :: X ()
hook = spawnOnce "bash ~/.config/autostart.sh"
