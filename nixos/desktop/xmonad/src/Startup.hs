module Startup (hook) where

import XMonad (X)
import XMonad.Util.SpawnOnce (spawnOnce)

hook :: X ()
hook = spawnOnce "bash ~/.config/autostart.sh"
