import XMonad
import XMonad.Config.Gnome (gnomeConfig)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Hooks.ManageDocks (avoidStruts)

import qualified XMonad.StackSet as W

import IM (imLayout)
import Keys (myModMask, myKeys, myMouseBindings)

imWorkspace = "5"

main = do
    xmonad $ gnomeConfig
        { terminal = "gnome-terminal"
        , focusFollowsMouse  = False
        , modMask = myModMask
        , keys = myKeys <+> keys gnomeConfig
        , mouseBindings = myMouseBindings
        , layoutHook = myLayout
        , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
        }

myManageHook =
    [ resource  =? "synapse"        --> doIgnore
    , className =? "Gimp-2.6"       --> doFloat
    , className =? "Exe"            --> doFloat -- Float Chrome browse window
    , className =? "Pidgin"         --> doF (W.shift imWorkspace)
    ]

myLayout =  avoidStruts $ smartBorders $ onWorkspace imWorkspace imLayout $
            layoutHook gnomeConfig
