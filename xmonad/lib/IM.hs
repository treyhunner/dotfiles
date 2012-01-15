module IM where

import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Reflect (reflectHoriz)

imLayout = reflectHoriz $ withIM ratio roster chatLayout where
    chatLayout      = Grid
    ratio           = 2%9
    roster          = And (ClassName "Pidgin") (Role "buddy_list")
