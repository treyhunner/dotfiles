module Keys where

import XMonad
import XMonad.Actions.CycleWS (toggleWS, nextScreen, shiftNextScreen)
import XMonad.Actions.NoBorders (toggleBorder)
import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M

xK_TV = 0x1008ff41 -- ThinkVantage button

altM = mod1Mask
winM = mod4Mask
shiftM = shiftMask

myModMask = winM

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList

    -- Custom window manager shortcuts
    [ ((modm .|. shiftM , xK_l)     , io (exitWith ExitSuccess))
    , ((modm            , xK_z)     , toggleWS)
    , ((modm            , xK_b)     , withFocused toggleBorder)
    , ((modm            , xK_g)     , sendMessage ToggleStruts)
    , ((winM            , xK_Tab)   , nextScreen)
    , ((winM .|. shiftM , xK_Tab)   , shiftNextScreen)
    , ((altM            , xK_Tab)   , windows W.focusDown)
    , ((altM .|. shiftM , xK_Tab)   , windows W.focusUp)
    , ((altM            , xK_F4)    , kill)

    -- Program launchers
    , ((winM            , xK_v)     , spawn "gvim")
    , ((winM .|. shiftM , xK_v)     , spawn "gksudo gvim")
    , ((winM            , xK_c)     , spawn "speedcrunch")
    , ((winM            , xK_a)     , spawn "nautilus")
    , ((winM            , xK_o)     , spawn "ooffice")

    ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((altM, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((altM, button2), (\w -> focus w >> windows W.swapMaster))
    , ((altM, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

