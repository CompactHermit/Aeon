-- Author: Compact Hermitian
-- http://github.com/CompactHermit
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use const" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-unused-do-bind #-}
{-# OPTIONS_GHC -Wno-missing-fields #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}


import System.IO
import System.Exit
import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators

import XMonad.Actions.PhysicalScreens
import XMonad.Actions.FloatKeys
import XMonad.Actions.WindowGo
import XMonad.Actions.CycleWindows
import XMonad.Actions.Workscreen hiding (workspaces)
import XMonad.Actions.CycleWS      -- (16) general workspace-switching
import XMonad.Actions.CycleRecentWS -- (17) cycle between workspaces
                                    --      in most-recently-used order
import XMonad.Actions.Warp         -- (18) warp the mouse pointer
import XMonad.Actions.WindowMenu --- Window Menu --- Window Menu
import XMonad.Actions.Submap       -- (19) create keybinding submaps
import XMonad.Actions.Search hiding (Query, images)
import XMonad.Actions.TopicSpace
import XMonad.Actions.GridSelect
import XMonad.Actions.WithAll
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.TagWindows
import XMonad.Actions.CopyWindow(copy)
import XMonad.Actions.SpawnOn ( manageSpawn )
import XMonad.Actions.EasyMotion
-- Hooks.
import XMonad.Hooks.DynamicLog hiding (trim)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops ( ewmh )

import XMonad.Config.Desktop

-- Layouts
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.MultiToggle
import XMonad.Layout.Spacing
-- import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Renamed  -- this replaces named.
import XMonad.Layout.Named
import XMonad.Layout.LayoutScreens
import XMonad.Layout.WorkspaceDir  -- (11) set working directory
import XMonad.Layout.ResizableTile -- (5)  resize non-master windows too
import XMonad.Layout.LayoutHints
import XMonad.Layout.MultiColumns
import XMonad.Layout.OneBig
import XMonad.Layout.Dishes
import XMonad.Layout.LimitWindows
import XMonad.Layout.Reflect
import XMonad.Layout.TwoPane
import XMonad.Layout.DwmStyle
import qualified XMonad.Layout.IM as IM
import XMonad.Layout.Fullscreen
    ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFloat, fullscreenFull)
import XMonad.Layout.NoBorders
import qualified XMonad.Layout.Dwindle as DW  -- Dwindle,Spiral and Squeeze.
import qualified XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.Tabbed
import XMonad.Layout.Roledex
import XMonad.Layout.Circle
import XMonad.Layout.Cross
import qualified XMonad.Layout.Grid as G
import XMonad.Layout.GridVariants ( Grid(..) )
import qualified XMonad.Layout.HintedTile as HT
import XMonad.Layout.StackTile
import XMonad.Layout.Accordion
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.Magnifier as Mag
import XMonad.Layout.LayoutModifier ( ModifiedLayout(..) )
import XMonad.Layout.MultiToggle.Instances
    ( StdTransformers(MIRROR, FULL) )

-- Prompts ---------------------------------------------------
import XMonad.Prompt                -- (23) general prompt stuff.
import XMonad.Prompt.Man            -- (24) man page prompt
import XMonad.Prompt.AppendFile     -- (25) append stuff to my NOTES file
import XMonad.Prompt.Ssh            -- (26) ssh prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Input          -- (26) generic input prompt, used for
                                    --      making more generic search
                                    --      prompts than those in
                                    --      XMonad.Prompt.Search
import XMonad.Prompt.Workspace      -- (27) prompt for a workspace

-- Utilities
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid ()
import Data.List
import Data.Function (on)
import Data.Ratio ((%))
import Data.Maybe (fromMaybe, fromJust, maybeToList)
import Data.Char (isSpace)


import XMonad.Util.Run
import XMonad.Util.Paste
import XMonad.Util.NamedWindows (getName)
import XMonad.ManageHook
import XMonad.Util.NamedScratchpad
import XMonad.Util.XSelection
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce ( spawnOnce )
import XMonad.Util.Hacks as Hacks

import qualified XMonad.DBus as D --For polybar
-- import qualified DBus.Client as D
-- import qualified Codec.Binary.UTF8.String as UTF8

import Control.Arrow hiding ((|||), (<+>))
import Control.Monad
import XMonad.Hooks.StatusBar
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Layout.ShowWName
import XMonad.Hooks.InsertPosition
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Simplest
import XMonad.Layout.Hidden
import XMonad.Layout.Gaps

-----------------------------------------------------------
-------------------Utils/Defaults--------------------------
-----------------------------------------------------------
myModMask = mod4Mask

-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False


-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 2

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--ICONS front font candy, can be replaced with something else
--
myClickJustFocuses :: Bool
myClickJustFocuses = False

myTerminal = "alacritty"

myShell = "nu"
emacsn = "emacsn"

-------------------------------------------------------------
-------------------THEMES----------------------------------
-----------------------------------------------------------
base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
magenta = "#d33682"
violet  = "#6c71c4"
cyan    = "#2aa198"
red     = "#dc322f"
blue    = "#268bd2"
green   = "#859900"
yellow  = "#b58900"
grey    = "#2E3440"

myNormalBorderColor  = inactive
myFocusedBorderColor = "#268bd2" -- "#ffb6b0"
myActiveBorderColor  = "#007c7c"


fg        = "#ebdbb2"
bg        = "#282828"
gray      = "#a89984"
bg1       = "#3c3836"
bg2       = "#505050"
bg3       = "#665c54"
bg4       = "#7c6f64"

pbGreen     = "#08cc86"
pbDarkgreen = "#000a06"
pbRed       = "#fb4934"
pbDarkred   = "#cc241d"
pbYellow    = "#fabd2f"
pbBlue      = "#83a598"
pbPurple    = "#fab6fb"
pbCyan      = "#00FFFF"
pbAqua      = "#8ec07c"
pbWhite     = "#eeeeee"

pbBlue2     = "#2266d0"

-- orange = myColor "#9f6225"
-- pink   = myColor "#9f2562"
-- purple = myColor "#62259f"
myBack    = "#1a1a1a" -- Bar background
myFore    = "#999999" -- Bar foreground
myAcc     = "#25629f" -- Accent color
myHigh    = "#629f25" -- Highlight color
myLow     = "#000000" -- Lowlight color
myVis     = "#9f2562" -- Visible Workspace
myEmpt    = "#555555" -- Empty workspace

crizer :: String -> Bool -> X(String, String)
crizer _ False = return ("#002b36", "#839496")
crizer _ True = return ("#839596", "#002b36")

gap         = 10
topbar      = 10
border      = 0
prompt'      = 20
status      = 20
active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

-- Colorizer generator
myColor color _ isFg = do
  return $ if isFg
           then (color, myLow)
           else (myLow ,color)

-- Colorizer colors for GridSelect
--aqua   = myColor "#259f62"
blue'   = myColor "#25629f"
green'  = myColor "#629f25"
-- red'    = myColor "#964400"

-- basically tabs since I don't have anything else
myFont      = "xft:JuliaMono Regular:pixelsize=11:antialias=true:hinting=true"
myBigFont   = "xft:JuliaMono Regular:pixelsize=16:antialias=true:hinting=true"
myWideFont  = "xft:JuliaMono Bold:pixelsize=20:antialias=true:hinting=true"
myMonoFont = "Source Code Pro"
myfontwsize = "xft:" ++ myFont ++ ":size=16"

-----------------------------------------
--- Tab Config
myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = blue
    , activeColor           = blue
    , activeTextColor       = blue
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = 10
    }
myShowWNameTheme = def
    { swn_font              = myWideFont
    , swn_fade              = 0.5
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }


-- theme settings for tabs and deco layouts.
myTheme :: Theme
myTheme = def {
  fontName = "xft:" ++ myFont ++ ":pixelsize=14"
  , decoHeight = 20
  , decoWidth = 400
  , activeColor = myFocusedBorderColor
  , inactiveColor = "#262626"
  , urgentColor = "#073642"
  , activeBorderColor = myFocusedBorderColor
  , inactiveBorderColor = "#586e75"
  , urgentBorderColor = "#586e75"
  , activeTextColor = "#CEFFAC"
  , inactiveTextColor = "#839496"
  , urgentTextColor = "#dc322f"
}

barFull = avoidStruts Simplest
data FULLBAR = FULLBAR deriving (Read, Show, Eq, Typeable)
instance Transformer FULLBAR Window where
    transform FULLBAR x k = k barFull (\_ -> x)


-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = def {
  fontName = "xft:" ++ myFont ++ ":pixelsize=14",
  activeBorderColor = "#007C7C",
  activeTextColor = "#CEFFAC",
  activeColor = myFocusedBorderColor,
  inactiveBorderColor = "#7C7C7C",
  inactiveTextColor = "#EEEEEE",
  inactiveColor = "#000000"
}


-----------------------------------------
-- Settings for the dzen sub-keymap -----
-----------------------------------------
menuPopKeyColor = "yellow"
menuPopCmdColor = "cyan"
-- double double quoted so it can make it all the way to dzen.
menuPopLineHeight = "24"
menuPopDzenFont = "xft:VictorMono Nerd Font:size=60"


-------------------------------------------------------------------------
-- Rofi Prompt and other Simple spawns-----------------------------------
-------------------------------------------------------------------------


-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "screenshot"






-------------------------------------------------------------------------
-------------------- GRIDSELECT, XPCONFIG, and EASYMOTION----------------
-------------------------------------------------------------------------
emConf :: EasyMotionConfig
emConf =
  def
    { txtCol = "#3f3c6d",
      bgCol = myFocusedBorderColor,
      borderCol = myFocusedBorderColor,
      cancelKey = xK_Escape,
      emFont = "xft:VictorMono Nerd Font:size=60",
      overlayF = textSize,
      borderPx = 30
    }
myXPConfig = def --  defaultXPConfig
    { fgColor = "#2fcbff"
    , bgColor = "#3f3c6d"
    , font = "xft:VictorMono Nerd Font:size=14"
    , height = 96
    }

-- grid select workspaces
workspaceGsConfig = def -- defaultGSConfig
           {gs_colorizer = crizer
           , gs_cellheight  = 150
           , gs_cellpadding = 5
           , gs_cellwidth   = 400
           , gs_navigate   = myNavigation
           , gs_font = "xft:Source Code Pro:pixelsize=48"
           }


-- get scratchpads, searchstuff, selectSearchStuff
-- give it a color for the grid when you use it.
coloredGSConfig colorizer = (buildDefaultGSConfig colorizer)
                       { gs_cellheight  = 95
                       , gs_cellpadding = 5
                       , gs_cellwidth   = 300
                       , gs_navigate   = myNavigation
                       , gs_font = "xft:Source Code Pro:pixelsize=40"
                       }


-------------------------------------------------------------------------
----------------- TopicWorkspaces and workspaces config------------------
-------------------------------------------------------------------------


myTopics :: [TopicItem]
myTopics = [ TI "\63083" "" (spawnInTopicDir "kitty nu") --1
            , TI "\63288" "" (spawnInTopicDir "firefox-nightly") --2
            , TI "\63306" "" (return ()) --3
            , TI "\61723" "" (spawnInTopicDir "zotero") --4
            , TI "\63107" "" (spawnInTopicDir "zeal" >> spawnInTopicDir "anki") --5
            , TI "\63601" "" (spawnInTopicDir "webcord") --6
            , TI "\63391" "" (return ()) --7
            , TI "\61713" "" (spawnInTopicDir "scid") --8
            , TI "\61884" "" (spawnInTopicDir "emacs") --9
            ]

myTopicNames :: [Topic]
myTopicNames = map tiName myTopics

myTopicConfig :: TopicConfig
myTopicConfig = TopicConfig
    { topicDirs = M.fromList $ map (tiName &&& tiDir) myTopics
    , defaultTopicAction = const $ return ()
    , defaultTopic = ""
    , topicActions = M.fromList $ map (tiName &&& tiAction) myTopics
    }

-- --- Prompted workspace navigation. ---------------------------------

spawnInTopicDir act = currentTopicDir myTopicConfig >>= spawnIn act

-- spawnShell :: X ()
-- spawnShell =  asks (terminal . config) >>= spawnInTopicDir

spawnShellIn :: Dir -> X ()
spawnShellIn dir = asks (terminal . config) >>= flip spawnIn dir

spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

-- spawnShellIn :: Dir -> X ()
-- spawnShellIn dir = spawn $ "urxvt '(cd ''" ++ dir ++ "'' && " ++ myShell ++ " )'"

spawnIn act dir = spawn $ "cd " ++ dir ++ "; " ++ act


-- --- Choose your method:  prompts or Grid select.  - These are prompts.
goto :: Topic -> X ()
goto = switchTopic myTopicConfig

-- promptedShift :: X ()
-- promptedShift = workspacePrompt myXPConfig $ windows . W.shift

--------------------------------------------------------------------------------
-- Polybar, xmobar, xfce4-panel, gnome-panel, kde-panel, etc.
--
-- pretty communication with the the dbus.
-- I use a completely transparent panel for this. The background image
-- has a nice multi-colored bar across the top of it. - oceanpark114.jpg
-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Hooks-DynamicLog.html

-- this one is for polybar
-----------------------------------------------------------
-------------------Dbus PP and Polybar---------------------
-----------------------------------------------------------

 -- * Polybar PP
myLogHook dbus = def
    { ppOutput = D.send dbus
    , ppSep = ""
    , ppLayout = wrap ("%{B" ++ grey ++ "}  ") "  %{B-}"
    , ppTitle = shorten 0
    , ppOrder = \(_:l:_:_) -> [l]
    }

myPolybar :: StatusBarConfig
myPolybar =
  def
    {
      sbStartupHook = spawn "~/.config/polybar/launch.sh --cuts",
      sbCleanupHook = spawn "killall polybar"
    }

-----------------------------------------------------------
------------------- Scratch Pads--------------------------
-----------------------------------------------------------


-- location and dimension.

scratchpadSize = W.RationalRect (1/4) (1/4) (1/3) (3/7)

mySPFloat = customFloating scratchpadSize

            -- with a flexible location.
-- Big BSP, Small SSP, Super small,
--  so size is width and height. - change the fractions to get your sizes right.
flexScratchpadSize dx dy = W.RationalRect (dx) (dy) (1/2) (5/7)
flexSScratchpadSize dx dy = W.RationalRect (dx) (dy) (3/5) (5/8)
flexSSScratchpadSize dx dy = W.RationalRect (dx) (dy) (1/2) (1/2)
-- pass in a fraction to determine your x,y location. size is derived from that
-- all based on screen size.
flexFloatSSP dx dy = customFloating (flexSScratchpadSize dx dy)
flexFloatSSSP dx dy = customFloating (flexSSScratchpadSize dx dy)
flexFloatBSP dx dy = customFloating (flexScratchpadSize dx dy)


-- TODO:: make repl designed with a function::
    --takes some list [xs] and foldr the name into boilerplate
scratchpads =
  [ NS "conky"   spawnConky findConky manageConky
  , NS "pavuControl"   spawnPavu findPavu managePavu
  , NS "term0"  (myTerminal ++ " --title term") (title =? "term") (flexFloatBSP (1/20) (1/20))
  , NS "term1" (myTerminal ++ " --title term1  -e nu") (title =? "term1") (flexFloatBSP (2/20) (2/20))
  , NS "term2" (myTerminal ++ " --title term2 -e nu") (title =? "term2") (flexFloatBSP (3/20) (3/20))
  , NS "term3" ("kitty --title term3 nu") (title =? "term3") (flexFloatBSP (4/20) (4/20))
  , NS "term4" (myTerminal ++ " --title term4") (title =? "term4") (flexFloatBSP (6/20) (4/20))
  , NS "lf"  (myTerminal ++ " --title lf_ub -e lfub") (title =? "lf_ub") (flexFloatBSP (6/20) (1/10))
  , NS "ghci"  (myTerminal ++ " --title ghci -e ghci") (title =? "ghci") (flexFloatBSP (6/20) (1/10))
  , NS "evcxr"  (myTerminal ++ " --title evcxr -e evcxr") (title =? "evcxr") (flexFloatBSP (6/20) (1/10))
  , NS "nickel"  (myTerminal ++ " --title nickel_repl -e nickel repl") (title =? "nickel_repl") (flexFloatBSP (6/20) (1/10))
  , NS "julia"  (myTerminal ++ " --title julia -e julia") (title =? "julia") (flexFloatBSP (4/20) (1/10))
  , NS "nix"  (myTerminal ++ " --title nix_repl -e nix repl --file '<nixpkgs>'") (title =? "nix_repl") (flexFloatBSP (6/20) (1/10))
  , NS "btop"   (myTerminal ++ " -e btop") (title =? "btop") (flexFloatSSP (1/4) (1/4))
  , NS "alsaMixer"  (myTerminal ++ " -e alsamixer -t alsamixer") (title =? "alsamixer") (flexFloatSSSP (1/4) (1/4))
  ]
  where
    spawnConky  = "conky -c ~/.config/conky/Erics.conkyrc" -- launch conky:: TODO:: Make Hydra mode for this
    findConky   = title =? "system_conky"   -- its window,  has a own_window_title of "system_conky"
    manageConky = (flexFloatSSP (1/4) (1/4))
    spawnPavu  = "pavucontrol"
    findPavu   = title =? "pavucontrol"
    managePavu = (flexFloatSSP (1/4) (1/4))

-- Scratchpad invocation / Dismissal
-- Warp
bringMouse = warpToWindow (9/10) (9/10)
scratchToggle a = namedScratchpadAction scratchpads a

-----------------------------------------------------------
-------------------GridSelect Themes-----------------------------
-----------------------------------------------------------

----Gridselect Navigation module, defining the required gridMovement,

--        note:: all gridselections should follow this modules

myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [
          ((0,xK_Escape), cancel)
         ,((0,xK_Return), select)
         ,((0,xK_slash) , substringSearch myNavigation)
         ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
         ,((0,xK_h)     , move (-1,0)  >> myNavigation)
         ,((0,xK_Right) , move (1,0)   >> myNavigation)
         ,((0,xK_l)     , move (1,0)   >> myNavigation)
         ,((0,xK_Down)  , move (0,1)   >> myNavigation)
         ,((0,xK_j)     , move (0,1)   >> myNavigation)
         ,((0,xK_Up)    , move (0,-1)  >> myNavigation)
         ,((0,xK_k)     , move (0,-1)  >> myNavigation)
         ,((0,xK_y)     , move (-1,-1) >> myNavigation)
         ,((0,xK_i)     , move (1,-1)  >> myNavigation)
         ,((0,xK_n)     , move (-1,1)  >> myNavigation)
         ,((0,xK_m)     , move (1,-1)  >> myNavigation)
         ,((0,xK_space) , setPos (0,0) >> myNavigation)
         ]
       navDefaultHandler = const myNavigation

-- Custom Colorizer

      --Main Colorizer ::
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                (0x28,0x2c,0x34) -- lowest inactive bg
                (0x28,0x2c,0x34) -- highest inactive bg
                (0xc7,0x92,0xea) -- active bg
                (0xc0,0xa7,0x9a) -- inactive fg
                (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_navigate    = myNavigation
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }





spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 180
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }


----------------------------------------------------------------
-------------------Grid-Select Menus----------------------------
----------------------------------------------------------------



gsCategories =
  [ ("Games",      "xdotool key super+alt+1")
  , ("Education",  "xdotool key super+alt+2")
  , ("Internet",   "xdotool key super+alt+3")
  , ("Multimedia", "xdotool key super+alt+4")
  , ("Office",     "xdotool key super+alt+5")
  , ("Settings",   "xdotool key super+alt+6")
  , ("System",     "xdotool key super+alt+7")
  , ("Utilities",  "xdotool key super+alt+8")
  ]

gsGames =
  [ ("0 A.D.", "0ad")
  , ("Battle For Wesnoth", "wesnoth")
  , ("OpenArena", "openarena")
  , ("Sauerbraten", "sauerbraten")
  , ("Steam", "steam")
  , ("Unvanquished", "unvanquished")
  , ("Xonotic", "xonotic-glx")
  ]

gsEducation =
  [ ("GCompris", "gcompris-qt")
  , ("Scid", "scid")
  , ("Zotero", "zotero")
  ]

gsInternet =
  [ ("Brave", "brave")
  , ("Discord", "discord")
  , ("Element", "element-desktop")
  , ("Librewolf", "Librewolf")
  , ("Syncthing", "syncthing-gtk")
  , ("Qutebrowser", "qutebrowser")
  , ("Qbittorent", "qBittorent")
  ]

gsMultimedia =
  [ ("Audacity", "audacity")
  , ("Blender", "blender")
  , ("Deadbeef", "deadbeef")
  , ("Kdenlive", "kdenlive")
  , ("OBS Studio", "obs")
  , ("VLC", "vlc")
  ]

gsSystem =
  [ ("Alacritty", "alacritty")
  , ("Bash", (myTerminal ++ " -e bash"))
  , ("Nvim", (myTerminal ++ " -e nvim"))
  , ("PCManFM", "pcmanfm")
  , ("VirtualBox", "virtualbox")
  , ("Zsh", (myTerminal ++ " -e zsh"))
  , ("Zathura", "zathura-tabbed")
  ]

gsUtilities =
  [ ("Emacs", "emacs")
  , ("Emacsclient", "emacsclient -c -a 'emacs'")
  , ("Vim", (myTerminal ++ " -e vim"))
  , ("Neovide", "neovide")
  ]


-- This is how to make a runSelectedAction grid select menu.
-- A grid select for scratchpads.
myScratchpadMenu =
  [ ("Conky", (scratchToggle "conky"))
  , ("Volume",(scratchToggle "pavuControl"))
  , ("Music mixer", (scratchToggle "alsaMixer"))
  , ("GHCI",  (scratchToggle "ghci"))
  , ("Top",   (scratchToggle "btop"))
  , ("evcxr",   (scratchToggle "evcxr"))
  , ("nix",   (scratchToggle "nix"))
  , ("nickel",   (scratchToggle "nickel"))
  , ("julia",   (scratchToggle "julia"))
  -- at the end because that puts them on the outside edges of select-grid.
  , ("a Term", (scratchToggle "term0"))
  , ("o Term", (scratchToggle "term1"))
  , ("e Term", (scratchToggle "term2"))
  , ("u Term", (scratchToggle "term3"))
  , ("h Term", (scratchToggle "term4"))
  , ("lf", (scratchToggle "lf"))
  ]

-- The scratch pad sub keymap
namedScratchpadsKeymap = -- Scratch Pads
    [ ("a", scratchToggle "term0") -- Term
    , ("o", scratchToggle "term1") -- Term1
    , ("e", scratchToggle "term2") -- Term2
    , ("u", scratchToggle "term3") -- Term3
    , ("h", scratchToggle "term4") -- Term4
    , ("l", scratchToggle "lf") --   LF
    , ("g", scratchToggle "ghci") -- ghci Repl
    , ("r", scratchToggle "evcxr") -- Rust Repl
    , ("j", scratchToggle "julia") -- Julia Repl
    , ("k", scratchToggle "nickel") -- Julia Repl
    , ("n", scratchToggle "nix") -- Nix Repl
    , ("C", scratchToggle "conky") -- Conky
    , ("v", scratchToggle "pavuControl") -- Pavu Control
    , ("m", scratchToggle "alsaMixer") -- Pavu Control
    , ("t", scratchToggle "top") -- htop
    ]

myScratchpadManageHook = namedScratchpadManageHook scratchpads


-- More grid select Menus
-- I just never use these. Leaving in case I change my mind.
--- grid select for some apps.
myApps = [("Terminal",     (spawn     myTerminal))

         ,("librewolf",      (runOrRaiseNext  "librewolf" (className =? "librewolf")))
         -- ,("Firefox",      (raiseApp  "fox" "firefox"))
         -- ,("Chromium",     (raiseApp  "web" "chromium"))

         ,("Emacs",        (spawn "emacsn -m Code"))
         ,("Inscape",        (runOrRaise "inkscape" (className =? "Inkscape")))
         ,("Gimp",         (runOrRaise "gimp" (className =? "gimp")))
         ,("Krita",         (runOrRaise "krita" (className =? "krita")))
         -- ,("Inkscape",     (raiseApp  "ink" "inkscape"))

         -- ,("Dolphin",      (runOrRaise "dolphin" (className =? "dolphin")))
         ,("LibreOffice",  (runOrRaise "libreoffice" (className =? "libreoffice")))

         ,("Video",        (runOrRaise "vlc" (className =? "vlc")))
         ]

------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- Pretty much I either float them, or ignore them. Shifting them, with
-- doShift, on invocation to another desktop is something I never do.
-- Topics automatically launches things by workspace, So I never have
-- a need for that.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
-- To match on the WM_NAME use 'title'
--
myManageHelpers = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- classFloats]
    , [ title       =? t --> doFloat           | t <- titleFloats]
    , [ resource    =? r --> doFloat           | r <- resourceFloats]
    , [ title       =? c --> doIgnore          | c <- titleIgnores]
    , [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat]
    ]
  where classFloats    = ["Galculator", "Steam", "Media_Center_30", "YACReaderLibrary",
                          "MPlayer", "Gimp", "Gajim.py", "Xmessage"]
        titleFloats    = ["Volume Control", "alsamixer", "Onboard"]
        resourceFloats = ["desktop_window", "Dialog", "gpicview"]
        titleIgnores   = ["stalonetray", "xfce4-notifyd"]

myManageHook' = myManageHelpers <+> myScratchpadManageHook

myManageHook :: ManageHook
myManageHook =
        manageSpecific
    <+> fullscreenManageHook
    <+> manageSpawn
    <+> myScratchpadManageHook
    where
        manageSpecific = composeAll
            [ resource =? "desktop_window" --> doIgnore
            , isRole =? gtkFile  --> forceCenterFloat
            , isDialog --> doCenterFloat
            , isRole =? "pop-up" --> doCenterFloat
            , isInProperty "_NET_WM_WINDOW_TYPE"
                           "_NET_WM_WINDOW_TYPE_SPLASH" --> doCenterFloat
            , resource =? "console" --> tileBelowNoFocus
            , isFullscreen --> doFullFloat
            , pure True --> tileBelow ]
        -- isBrowserDialog = isDialog <&&> className =? myBrowserClass
        gtkFile = "GtkFileChooserDialog"
        isRole = stringProperty "WM_WINDOW_ROLE"
        -- insert WHERE and focus WHAT
        tileBelow = insertPosition Below Newer
        tileBelowNoFocus = insertPosition Below Older
forceCenterFloat :: ManageHook
forceCenterFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2

---------------------------------------------------------------------------------
myEventHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

  where fmt currWs ws
          | currWs == ws = "[" ++ ws ++ "]"
          | otherwise    = " " ++ ws ++ " "
        sort' = sortBy (compare `on` (!! 0))



---------------------------------------------------------------------
--Layouts -----------------------------------------------------------
---------------------------------------------------------------------
-- So Many layouts. Giving them names, keeping it down to ones that I use or used.
-- It's a bit easier to deal with individually Instead of with a big
-- intertwined where, mixed with the onworkspace directives it's too much.

myBSP             = BSP.emptyBSP
myCross           = simpleCross
myStackTile       = StackTile 1 (3/100) (1/2)
myHintedGrid      = G.GridRatio (4/3)
myDishes          = Dishes 2 (1/6)
myDwindle         = DW.Dwindle DW.R DW.CW (3/2) (11/10)
mySpiral          = DW.Spiral DW.L DW.CW (3/2) (11/10)
mySqueeze         = DW.Squeeze DW.D (3/2) (11/10)
myCols            = multiCol [1] 2 (3/100) (1/2)
my3ColMid         = ThreeColMid 1 (3/100) (1/2)
    -- where
        -- mySpacing           = spacing gap
        -- myGaps              = gaps [(U, gap),(D, gap),(L, gap),(R, gap)]

myBook            = ThreeColMid nmaster delta ratio
    where

        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 2/3

myTwoPane         = TwoPane (3/100) (1/2)
myTall            = Tall 1 (3/100) (1/2)
myTabbed          = named "Tabs" $ avoidStruts $ noFrillsDeco shrinkText topBarTheme $ addTabs shrinkText myTabTheme Simplest
myGrid            = Grid (8/4)
myNoBorders       = noBorders (fullscreenFull Full)
myAccordion       = Accordion
myMAccordion      = Mirror (Accordion)
myWide2           = Mirror (Tall 1 (3/100) (1/2))
myWide            = Mirror $ Tall nmaster delta ratio
    where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 80/100

-- Magnifier layouts.
-- Increase the size of the window that has focus by a custom zoom, unless if it is the master window.
-- myCode            = limitWindows 3 $ magnifiercz' 1.4 $ FixedColumn 1 20 80 10

myMagBSP          = Mag.magnifier BSP.emptyBSP

mySplit = Mag.magnifiercz' 1.4 $ Tall nmaster delta ratio
    where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 60/100

myMagTiled = Mag.magnifier tiled
  where
    tiled = Tall tnmaster tdelta ratio
    tnmaster = 1
    ratio = 1/2
    tdelta = 3/100

myHTTall = hintedTile HT.Tall
  where
     hintedTile = HT.HintedTile nmaster delta ratio HT.TopLeft
     nmaster    = 1
     ratio      = 1/2
     delta      = 3/100

myHTWide = hintedTile HT.Wide
  where
     hintedTile = HT.HintedTile nmaster delta ratio HT.TopLeft
     nmaster    = 1
     ratio      = 1/2
     delta      = 3/100

-- with IM to get a sidebar with grid in the other part
myChat' l = IM.withIM size roster l
    where
        -- Ratio of screen roster will occupy
        size = 1%5
        -- Match roster window
        roster = IM.Title "Buddy List"
myChat = myChat' G.Grid

-- For tailing logs ?
myDish = limitWindows 5 $ Dishes nmaster ratio
    where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by other panes
        ratio = 1/5

-- example of withIM
-- Dishes with a sidebar for ProcMeter3 or whatever
myDishBar' l = reflectHoriz $ IM.withIM procmeterSize procmeter $
              reflectHoriz $ l
    where
        -- Ratio of screen procmeter will occupy
        procmeterSize = 1%7
        -- Match procmeter
        procmeter = IM.ClassName "ProcMeter3"
myDishesSidebar = myDishBar' myDish

-----------------------------------------------------------------------
-- Group the layouts and assign them to workspaces.

genLayouts = avoidStruts (
    named "BSP" BSP.emptyBSP |||
    named "GGrid" G.Grid |||
    named "GridH" myGrid |||
    named "3ColMid" my3ColMid |||
    named "Columns" myCols |||
    named "Tall" myTall |||
    named "Wide" myWide |||
    named "Wide2" myWide2 |||
    named "Dishes" myDish |||
    named "HintTall" myHTTall |||
    named "HintWide" myHTWide |||
    named "Tabbed" myTabbed |||
    named "Roledex" Roledex |||
    named "TwoPane" myTwoPane |||
    named "Circle" Circle |||
    named "Cross" myCross |||
    named "Book" myBook |||
    named "Mag BSP" myMagBSP |||
    named "Mag Tiled" myMagTiled |||
    named "Stack Tile" myStackTile |||
    named "Accordion" myAccordion |||
    named "Accordion V" myMAccordion |||
    named "Spiral" mySpiral |||
    named "Squeeze" mySqueeze |||
    named "Dwindle" myDwindle |||
    named "Full" Full |||
    named "NoBorders" myNoBorders)

---------------------------------------------------------
-- A menu/grid-select menu for the named layouts above.
-- All the names. For the prompt and the GridSelect.
allLayouts = ["BSP"
             , "GGrid"
             , "GridH"
             , "3ColMid"
             , "Columns"
             , "Tall"
             , "Wide"
             , "Wide2"
             , "Dishes"
             , "HintTall"
             , "HintWide"
             , "Tabbed"
             , "Roledex"
             , "TwoPane"
             , "Circle"
             , "Cross"
             , "Book"
             , "Mag BSP"
             , "Mag Tiled"
             , "Stack Tile"
             , "Accordion"
             , "Accordion V"
             , "Spiral"
             , "Squeeze"
             , "Dwindle"
             , "Full"
             , "NoBorders"
             ]



-----------------------------------------------------------
--------Atom Support/Speciali window hints-----------------
-----------------------------------------------------------


addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]



-- The gridSelect menu.
layoutsGS = [ (s, sendMessage $ JumpToLayout s) | s <- allLayouts ]


-----------------------------------------------------------
-------LayoutHooks and other wonky layouts-----------------
-----------------------------------------------------------


myLayout =
              fullscreenFloat -- fixes floating windows going full screen, while retaining "bounded" fullscreen
             $ fullBarToggle
             $ hiddenWindows
             -- $ reflectToggle
             $

  onWorkspace "Web" simpleSquares $
  onWorkspaces ["Code", "QMK", "Xmonad", "Elisp", "Arch Setup"] codeLayouts $

  onWorkspace "kicad" kicadLayouts $
  onWorkspace "comm" commLayouts $

  onWorkspaces ["krita", "inkscape", "gravit", "Xournal"] artLayouts $

  onWorkspace "3D" threeDLayouts $
  onWorkspace "BD" bdLayouts $

  onWorkspace "Music" mediaLayouts $
  onWorkspace "Movies" mediaLayouts $
  onWorkspace "French" langLayouts $
  onWorkspace "Downloads" bdLayouts

  genLayouts
    where
        fullBarToggle       = mkToggle (single FULLBAR)
        -- reflectToggle       = mkToggle (single REFLECTX)
        -- mirrorToggle       = mkToggle (single MIRRORX)
        simpleSquares = myTwoPane ||| myMagTiled   ||| myTall       ||| myCols       ||| myGrid      ||| myMagTiled
        kicadLayouts  = myMagBSP  ||| myMagTiled   ||| myTall       ||| myCross      ||| Circle
        codeLayouts   = myMAccordion ||| myTall    ||| myGrid       ||| Roledex
        commLayouts   = myMagBSP  ||| myMagTiled   ||| myTall       ||| myBSP        ||| myStackTile ||| myGrid
        artLayouts    = Full      ||| myMagBSP     ||| myMAccordion ||| myTall       ||| myDwindle   ||| Circle
        threeDLayouts = myMagBSP  ||| myMagTiled   ||| myMAccordion ||| myDwindle    ||| mySpiral
        bdLayouts     = mySplit   ||| myMAccordion ||| myMagTiled   ||| myStackTile
        mediaLayouts  = Full      ||| myNoBorders  ||| myGrid       ||| Circle       ||| myCross     ||| myTall
        langLayouts   = mySqueeze ||| myMagBSP     ||| myMagTiled   ||| myMAccordion ||| myDwindle   ||| mySpiral

mylayoutXPConfig = def { autoComplete = Just 1000 }

-- layout prompt (w/ auto-completion and all layouts)
-- myLayoutPrompt = inputPromptWithCompl mylayoutXPConfig "Layout"
--                     (mkComplFunFromList' allLayouts)
--                     ?+ (sendMessage . JumpToLayout)


-- modified variant of cycleRecentWS from XMonad.Actions.CycleRecentWS (17)
-- which does not include visible but non-focused workspaces in the cycle
-- cycleRecentWS' = cycleWindowSets options
--  where options w = map (W.view `flip` w) (recentTags w)
--       recentTags w = map W.tag $ W.hidden w ++ [W.workspace (W.current w)]


------------------------------------------------------------------------------------------
-- Prompts and searches and stuff.   GridSelect...

mypromptSearch a = promptSearch myXPConfig a

-- isGDHist a = (a == "GoldenDict:")

-- gDPrompt :: XPConfig -> X ()
-- gDPrompt c =
    -- inputPromptWithCompl c "GoldenDict:" (historyCompletionP isGDHist) ?+ \word ->
-- -- -- this causes the full sized goldendict to appear.
-- -- runProccessWithInput "goldendict" [] word
    -- safeSpawn "goldendict" [word]
         -- >> return ()

-- these don't actually work for some reason. The data scrolls out of the dzen bar.
sdcvPrompt :: XPConfig -> String -> X ()
sdcvPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "sdcv" ["-2 /SSD/usr/share/startdict"] input) >>= sdcvPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

-- Extra search engines for promptsearch and select search
chinese     = searchEngine "chinese"      "https://www.mdbg.net/chinese/dictionary?page=worddict&wdrst=0&wdqb="
arxivDB     = searchEngine "arxivDB"  "https://arxivxplorer.com/?query="
arxiv     = searchEngine "arxiv"      "https://arxiv.org/search/?query="
images    = searchEngine "images"     "http://www.google.com/search?hl=fr&tbm=isch&q="
reverso   = searchEngine "reverso"    "http://context.reverso.net/traduction/francais-anglais/"
arch      = searchEngine "arch"       "http://wiki.archlinux.org/index.php/Special:Search?search="
archpkgs  = searchEngine "archpkgs"   "https://www.archlinux.org/packages/?sort=&q="
archaur   = searchEngine "archaur"    "https://aur.archlinux.org/packages/?O=0&K="
thesaurus = searchEngine "thesaurus"  "http://thesaurus.reference.com/browse/"
etymology = searchEngine "etymology"  "http://www.etymonline.com/index.php?term="
synonymes  = searchEngine "synonyms"  "http://www.synonymes.com/synonyme.php?mot="
-- synonymes = searchEngine  "synonymes" "http://www.les-synonymes.com/mot/"
wiktionaryen = searchEngine "wiktionary" "https://en.wiktionary.org/w/index.php?search="
wiktionnaire = searchEngine "wiktionnaire" "https://fr.wiktionary.org/w/index.php?search="
clojuredocs = searchEngine "clojuredocs" "https://clojuredocs.org/clojure.core/"

----------------------------------------------------------------
-- Grid-Select menus -------------------------------------------

promptSearchMenu =
     [("duckduckgo",   (mypromptSearch duckduckgo))
     , ("Reverso",      (mypromptSearch reverso))
     , ("Wiktionary",   (mypromptSearch wiktionaryen))
     , ("Wiktionnaire", (mypromptSearch wiktionnaire))
     , ("Synonymes.fr", (mypromptSearch synonymes))
     , ("arxiv", (mypromptSearch arxiv))
     , ("arxivDB", (mypromptSearch arxivDB))
     , ("man",          (manPrompt myXPConfig))
--     , ("sdcv",         (sdcvPrompt myXPConfig "sdcv"))
     -- , ("goldendict",   (gDPrompt myXPConfig))
     , ("google",       (mypromptSearch google))
     , ("hoogle",       (mypromptSearch hoogle))
     , ("clojuredocs",  (mypromptSearch clojuredocs))
     , ("wikipedia",    (mypromptSearch wikipedia))
     , ("hackage",      (mypromptSearch hackage))
     , ("scholar",      (mypromptSearch scholar))
     , ("math World",   (mypromptSearch mathworld))
     , ("Maps",         (mypromptSearch maps))
     , ("Dictionary",   (mypromptSearch dictionary))
     , ("Alpha",        (mypromptSearch alpha))
     , ("Lucky",        (mypromptSearch lucky))
     , ("Images",       (mypromptSearch images))
     , ("chinese",        (mypromptSearch chinese))
     , ("Arch",         (mypromptSearch arch))
     , ("Arch Pkg",     (mypromptSearch archpkgs))
     , ("Arch AUR",     (mypromptSearch archaur))
     ]

selectSearchMenu =
     [ ("google",       (selectSearch google))
     -- , ("goldendict",   (promptSelection "goldendict"))
     , ("hoogle",       (selectSearch hoogle))
     , ("clojuredocs",  (selectSearch clojuredocs))
     , ("duckduckgo",   (selectSearch duckduckgo))
     , ("arxiv",   (selectSearch arxiv))
     , ("arxivDB",   (selectSearch arxivDB))
     , ("wikipedia",    (selectSearch wikipedia))
     , ("hackage",      (selectSearch hackage))
     , ("scholar",      (selectSearch scholar))
     , ("math World",   (selectSearch mathworld))
     , ("Maps",         (selectSearch maps))
     , ("Dictionary",   (selectSearch dictionary))
     , ("Alpha",        (selectSearch alpha))
     , ("Lucky",        (selectSearch lucky))
     , ("Images",       (selectSearch images))
     , ("chinese",        (selectSearch chinese))
     , ("Reverso",      (selectSearch reverso))
     , ("Arch",         (selectSearch arch))
     , ("Arch Pkg",     (selectSearch archpkgs))
     , ("Arch AUR",     (selectSearch archaur))
     , ("Wiktionary",   (selectSearch wiktionaryen))
     , ("Wiktionnaire", (selectSearch wiktionnaire))
     , ("Synonymes.fr", (selectSearch synonymes))
     ]

-------------------------------------------------------------------------------------------
-- Grid-select
-- The actual grid-select menu functions.
-- Automatic workspace grid select by getting the names from the topicspace.

-- Default navigation.  arrows/vi (hjkl) '/' for string search.
-- search by letter and/or arrows.

wsgrid = withWindowSet $ \w -> do
    let wss = W.workspaces w
        usednames = map W.tag $  wss
        newnames = filter (\used -> (show used `notElem` (map show myTopicNames))) usednames
    gridselect workspaceGsConfig (map (\x -> (x,x)) (myTopicNames ++ newnames))

-- gridselect a workspace and view it
promptedGoto = wsgrid >>= flip whenJust (switchTopic myTopicConfig)

-- gridselect a workspace to shift active window to
promptedShift = wsgrid >>= flip whenJust (windows . W.shift)

warpToCentre = gets (W.screen . W.current . windowset) >>= \x -> warpToScreen x  0.5 0.5

selectApps   = runSelectedAction (coloredGSConfig green') myApps
getScratchpad = runSelectedAction (coloredGSConfig blue') myScratchpadMenu
searchStuff = runSelectedAction (coloredGSConfig green') promptSearchMenu
selectSearchStuff = runSelectedAction (coloredGSConfig green') selectSearchMenu
layoutGridSelect = runSelectedAction (coloredGSConfig blue') layoutsGS
---------------------------------------------------------------------------
--- Key Map doc dzen popup ------------------------------------------------
---------------------------------------------------------------------------
-- Basically, this uses an awk script to parse xmonad.hs for the keymaps.
-- When you hit a key combo that has a subkeymap this script parses xmonad.hs
-- and displays a dzen popup with the possible completion choices for that
-- key submap.  so M-o gives me a popup of the possible scrathpads and their
-- corresponding key...  There might be a better way. But this works fine.

windowScreenSize :: Window -> X (Rectangle)
windowScreenSize w = withDisplay $ \d -> do
    ws <- gets windowset
    sc <- fromMaybe (W.current ws) <$> pointScreen 10 10 -- who cares where.

    return $ screenRect . W.screenDetail $ sc
  where fi x = fromIntegral x

focusedScreenSize :: X (Rectangle)
focusedScreenSize =
  withWindowSet $ windowScreenSize . fromJust . W.peek


keyMapDoc :: String -> X Handle
keyMapDoc name = do
       ss <- focusedScreenSize
       handle <- spawnPipe $ unwords ["~/Bin/showHintForKeymap.sh",
                                       name,
                                       show (rect_x ss),
                                       show (rect_y ss),
                                       show (rect_width ss),
                                       show (rect_height ss),
                                       menuPopKeyColor,
                                       menuPopCmdColor,
                                       menuPopDzenFont,
                                       menuPopLineHeight]
       return handle

-- send it off to awk. -> showHintForKeymap
toSubmap :: XConfig l -> String -> [(String, X ())] -> X ()
toSubmap c name m = do
  pipe <- keyMapDoc name
  submap $ mkKeymap c m
  io $ hClose pipe

------------------------------------------------------------------------
------------------------------------------------------------------------
-- Key bindings  EZ, lots of submaps.  Scratchpads are up above with
-- their friends.
--
-- Note: Formatting is important for script.  The comment becomes the menu text.
focusKeymap = -- Focus
  [ ("v",       focus "vivaldi") -- Focus Vivaldi
  , ("e",       focus "emacs") -- Focuse Emacs
  , ("m",       windows W.focusMaster) -- Focus Master
  , ("s",       windows W.swapMaster) -- Swap Master
  , ("/",       spawn menu) -- Menu
  , ("t",       withFocused $ windows . W.sink) -- Sink
  , ("k",    windows W.swapUp) -- Swap Up
  , ("j",  windows W.swapDown) -- Swap Down
  , ("z",       rotOpposite) -- Rotate Opposite
  , ("i",       rotUnfocusedUp) -- Rotate UnFocused UP
  , ("d",       rotUnfocusedDown) -- Rotate Focused Down
  , ("r",       refresh) -- Refresh
  , ("l", sendMessage MirrorExpand) -- Mirror Expand
  , ("h",  sendMessage MirrorShrink) -- Mirror Shrink
  , ("n",       shiftToNext) -- -> Next
  , ("p",       shiftToPrev) -- -> Prev
  , ("S-n",     shiftToNext >> nextWS) -- -> Next & follow
  , ("S-p",     shiftToPrev >> prevWS) -- -> Prev & follow
  ]
  where focus :: String -> X ()
        focus w = spawn ("wmctrl -a " ++ w)
        menu = "wmctrl -l | cut -d' ' -f 5- | sort | uniq -u | dmenu -i | xargs -IWIN wmctrl -F -a WIN"

-- musicKeymap = -- Music
--   [ ("n", mpc "next") -- Next
--   , ("N", mpc "prev") -- Prev
--   , ("p", mpc "toggle") -- Toggle
--   , ("r", mpc "random") -- Random
--   , ("l", mpc "repeat") -- Repeat
--   ]
--   where mpc c = spawn ("mpc " ++ c)

masterKeymap = -- Master Window
  [ ("f",      windows W.focusMaster) -- Focus
  , ("s",      windows W.swapMaster) -- Swap
  , ("h",      sendMessage Shrink) -- Shrink
  , ("l",      sendMessage Expand) -- Expand
  , ("k",      incMaster) -- Master++
  , ("j",      decMaster) -- Master--
  , ("<Up>",   incMaster) -- Master++
  , ("<Down>", decMaster) -- Master--
  ]
  where incMaster       = sendMessage (IncMasterN 1)
        decMaster       = sendMessage (IncMasterN (-1))


shotKeymap = -- Screen Shot
  [ ("c", setContext) -- Set Context
  , ("s", takeShot select) -- Take Select
  , ("w", spawn ("flameshot gui")) -- Flameshot
  , ("o", openDirectory) -- Open Directory
  ]
  where setContext = spawn ("~/.xmonad/sshot-context.sh")
        takeShot a = spawn ("scrot " ++ a ++ " ~/screenshots/current-context/'%Y-%m-%dT%H%M%S_$wx$h.png'")
        openDirectory = spawn ("xdg-open ~/screenshots/current-context/")
        select        = "-s"
        currentWindow = "-u"

-- Make sure you have $BROWSER set in your environment.
promptSearchKeymap = -- Search
     [ ("m", manPrompt myXPConfig) -- Man Pages
     -- , ("f", prompt "goldendict" myXPConfig) -- golden dict
     , ("g", promptSearch myXPConfig google) -- Google
     , ("d", promptSearch myXPConfig duckduckgo) -- duck duck go
     , ("w", promptSearch myXPConfig wikipedia) -- wikipedia
     , ("h", promptSearch myXPConfig hackage) -- hackage
     , ("a", promptSearch myXPConfig arxiv) -- Arxiv
     , ("S-a", promptSearch myXPConfig arxivDB) -- arxivDB
     , ("s", promptSearch myXPConfig scholar) -- Scholar
     , ("S-m", promptSearch myXPConfig mathworld) -- Math World
     , ("c", promptSearch myXPConfig maps) -- Maps / Cartes
     , ("S-d", promptSearch myXPConfig dictionary) -- Dictionary
     , ("a", promptSearch myXPConfig alpha) -- Alpha
     , ("l", promptSearch myXPConfig lucky) -- Lucky
     , ("i", promptSearch myXPConfig images) -- Images
     , ("k", promptSearch myXPConfig chinese) -- Chinese
     , ("r", promptSearch myXPConfig reverso) -- Reverso
     ]

selectSearchKeymap = -- Search Selected
    [
    -- , ("f", promptSelection "goldendict") -- golden dict
      ("d", selectSearch duckduckgo) -- Duckduckgo
    , ("w", selectSearch wikipedia) -- Wikipedia
    , ("h", selectSearch hackage) -- hackage
    , ("s", selectSearch scholar) -- Scholar
    , ("S-s", selectSearch arxiv) -- Arxiv
    , ("C-s", selectSearch arxivDB) -- ArxivDB
    , ("m", selectSearch mathworld) -- Mathworld
    , ("c", selectSearch maps) -- Maps / Cartes
    , ("S-d", selectSearch dictionary) -- Dictionary
    , ("a", selectSearch alpha) -- Alpha
    , ("l", selectSearch lucky) -- Lucky
    , ("i", selectSearch images) -- Images
    , ("k", selectSearch chinese) -- Chinese
    , ("r", selectSearch reverso) -- Reverso
    ]


 -- some prompts.
 -- ability to change the working dir for a workspace.
promptsKeymap = -- Prompts
        [ ("d",   changeDir myXPConfig) -- Change Dir
        , ("m",   manPrompt myXPConfig) -- Man Pages
        , ("r",   spawn "exe=`dmenu_run -fn myfontwize -b -nb black -nf yellow -sf yellow` && eval \"exec $exe\"") -- dmenu
        , ("n",   appendFilePrompt myXPConfig "$HOME/neorg/file.norg") -- Misc Notes
        , ("S-s", sshPrompt myXPConfig) -- SSH
        , ("z",   shellPrompt myXPConfig) -- Shell
        , ("s",   promptSearch myXPConfig $ intelligent multi) -- Multi Search
        ]

        -- , ("e", spawn "exe=`echo | yeganesh -x` && eval \"exec $exe\"")

magnifierKeymap = -- Magnifier
    [ ("+",   sendMessage Mag.MagnifyMore)  -- More
    , ("-",   sendMessage Mag.MagnifyLess)  -- Less
    , ("o",   sendMessage Mag.ToggleOff  )  -- Off
    , ("S-o", sendMessage Mag.ToggleOn   )  -- On
    , ("m",   sendMessage Mag.Toggle     )  -- Toggle
    ]

workspacesKeymap = -- Workspaces
    [ ("z",      toggleWS) -- toggle
    , ("n",      nextWS) -- Next
    , ("p",      prevWS) -- prev
    , ("o",      windowMenu) -- WindowMenu
    , ("k",   nextScreen) -- n S
    , ("j", prevScreen) -- p S
    , ("S-j",   shiftPrevScreen) -- Mp S
    , ("S-k",   shiftNextScreen) -- Mn S
    , ("S-n",    shiftToNext) -- Shift -> next
    , ("S-p",    shiftToPrev) -- shift -> prev
    , ("C-k",    shiftToNext >> nextWS) -- Shift -> Next & follow
    , ("C-j",    shiftToPrev >> prevWS) -- Shift -> Prev & follow
    , ("<Tab>",  cycleRecentWS [xK_Super_L, xK_Shift_L] xK_Tab xK_grave) -- Cycle Recent
    , ("S-z",    killAll >> DO.moveTo Prev (hiddenWS :&: Not emptyWS)) -- Kill All
    , ("a",      addWorkspacePrompt myXPConfig) -- Add
    , ("r",      removeEmptyWorkspace) -- Remove
    , ("s",      spawn("skippy-xd")) -- Overview
    , ("S-r",    renameWorkspace myXPConfig) -- Rename
    , ("C-l",  DO.swapWith Next (Not emptyWS)) -- Swap Next
    , ("C-h",  DO.swapWith Prev (Not emptyWS)) -- Swap Prev
    , ("S-l",  DO.shiftTo Next (hiddenWS :&: Not emptyWS)) -- Shift to Next
    , ("S-h",  DO.shiftTo Prev (hiddenWS :&: Not emptyWS)) -- Shift to Prev
    , ("l",    DO.moveTo Next (hiddenWS :&: Not emptyWS)) -- Move to Next
    , ("h",    DO.moveTo Prev (hiddenWS :&: Not emptyWS)) -- Move to Prev
    ]

rofiKeymap = -- Rofi Document Searcher
   [ ("h", spawn "~/bin/Com_papers.sh") -- ComSci paper search
   , ("j", spawn ("~/bin/papers.sh")) -- Paper Search
   , ("k", spawn ("~/bin/chess_search.sh")) -- Chess Search
   , ("l", spawn ("~/bin/book_search.sh")) -- Math Book Search
   , ("<Space>", spawn ("rofi -no-lazy-grab -show drun -modi run,drun,window -theme $HOME/.config/rofi/launcher/style -drun-icon-theme \'candy-icons\' ") ) -- Rofi Spawner
   ]


layoutKeymap = -- Layout
    [
--("f",   sendMessage (Toggle FULL)) --toggle Full
--, ("s",   sendMessage (Toggle SIDEBAR)) -- toggle sidebar
--, ("M-d", sendMessage (Toggle MAG)) -- toggle mag
--, ("S-f", sendMessage (Toggle RFULL)) -- Full without panel, border
      ("t",   withFocused $ windows . W.sink) -- sink focused window
    , ("S-t", sinkAll) -- sink all windows
    , ("r",   rescreen) -- Rescreen
    , ("2",   layoutSplitScreen 2 $ TwoPane (3/100) (1/2)) -- Split Screen two pane
    , ("3",   layoutSplitScreen 3 $ ThreeColMid 1 (3/100) (1/2)) -- Split Screen 3 Col
    , ("4",   layoutSplitScreen 4 $ G.Grid) -- Split Screen Grid
    ]

floatKeymap = -- Floating Windows
    [
    ("d",       withFocused (keysResizeWindow (0, 0) (0.5, 0.5))) -- Resize Smaller
    , ("s",       withFocused (keysResizeWindow (50,50) (1%2,1%2))) -- Resize Bigger
    , ("l", withFocused (keysMoveWindow (40,0) )) -- Move Right
    , ("j",  withFocused (keysMoveWindow (0,40) )) -- Move Down
    , ("h",  withFocused (keysMoveWindow (-40,0))) -- Move Left
--	, ("<Up>",    withFocused (keysMoveWindow (0,-40))) -- Move Up
    , ("S-s",     withFocused $ windows . W.sink) -- Sink

    , ("g",  moveFocusedWindowToRel (0,0)) -- Top Left
    , ("c",  moveFocusedWindowToRel (1%2, 0)) -- Top Center
    , ("r",  moveFocusedWindowToRel (1,0)) -- Top Right
    , ("h",  moveFocusedWindowToRel (0, 1%2)) -- Left Center
    , ("t",  moveFocusedWindowToRel (1%2, 1%2)) -- Center
    , ("n",  moveFocusedWindowToRel (1, 1%2)) -- Right Center
    , ("m",  moveFocusedWindowToRel (0,1)) -- Bottom Left
    , ("w",  moveFocusedWindowToRel (1%2, 1)) -- Bottom Center
    , ("v",  moveFocusedWindowToRel (1,1)) -- Bottom Right
    ] where
         moveFocusedWindowToRel (wMult, hMult) =
             do screenSize <- focusedScreenSize
                let screenX = round (wMult * fromIntegral (rect_width screenSize))
                    screenY = round (hMult * fromIntegral (rect_height screenSize))
                    sY = (if screenY == 0 then 40 else screenY)
                    sX = (if screenX == 0 then 40 else screenX)
                withFocused (keysMoveWindowTo (sX, sY) (wMult, hMult))

tagWindowKeymap = -- Window Tags
   [
   --   ("m",   withFocused (addTag "abc")) -- add tag "abc"
   -- , ("u",   withFocused (delTag "abc")) -- del tag "abc"
   -- , ("s",   withTaggedGlobalP "abc" W.sink) -- sink "abc"
   -- , ("d",   withTaggedP "abc" (W.shiftWin "2")) -- shift "abc" to 2
   -- , ("S-d", withTaggedGlobalP "abc" shiftHere) -- shift "abc" all here.
   -- , ("C-d", focusUpTaggedGlobal "abc") -- focus up all "abc"

     ("m",   tagPrompt myXPConfig (\s -> withFocused (addTag s))) -- add a tag to focused.
   , ("u",   tagPrompt myXPConfig (\s -> withFocused (delTag s))) -- delete a tag from focused.
   , ("S-u", tagDelPrompt myXPConfig) -- delete tag!
   , ("f",   tagPrompt myXPConfig (\s -> withTaggedGlobal s float)) -- float tagged
   -- , ("g",   tagPrompt myXPConfig (\s -> withTaggedP s (W.shiftWin "2"))) -- shift to 2
   , ("s",   tagPrompt myXPConfig (\s -> withTaggedGlobalP s W.sink)) -- sink
   , ("S-s", tagPrompt myXPConfig (\s -> withTaggedGlobalP s shiftHere)) -- shift here
   , ("'",   tagPrompt myXPConfig (\s -> focusUpTaggedGlobal s)) -- focus up.
   ]

-- BSP layout controls.
bspKeymap = -- BSP Layout Controls
    [ ("l",   sendMessage $ BSP.ExpandTowards R) -- Expand Right
    , ("h",    sendMessage $ BSP.ExpandTowards L) -- Expand Left
    , ("j",      sendMessage $ BSP.ExpandTowards D) -- Expand Down
    , ("k",    sendMessage $ BSP.ExpandTowards U) -- Expand Up
    , ("S-l", sendMessage $ BSP.ShrinkFrom R) -- Shrink Right
    , ("S-h",  sendMessage $ BSP.ShrinkFrom L) -- Shrink Left
    , ("S-j",  sendMessage $ BSP.ShrinkFrom D) -- Shrink Down
    , ("S-k",    sendMessage $ BSP.ShrinkFrom U) -- Shrink Up
    , ("r",         sendMessage BSP.Rotate) -- Rotate
    , ("s",         sendMessage BSP.Swap) -- Swap
    , ("p",         sendMessage BSP.FocusParent) -- Focus Parent
    , ("n",         sendMessage BSP.SelectNode) -- Select Node
    , ("m",         sendMessage BSP.MoveNode) -- Move Node
    , ("b",         sendMessage BSP.Balance) -- Balance
    , ("e",         sendMessage BSP.Equalize) -- Equalize
    ]

-- Eww
ewwKeymap = -- Eww Controls
    [("b", spawn ("eww -c ~/.config/eww open status_bar")) -- Spawn Bar
    ,("d", spawn ("eww -c ~/.config/eww open dashboard")) -- Spawn Dashboard
    ,("c", spawn ("eww -c ~/.config/eww close-all")) -- Kill eww
    ]
-- Raise
raiseKeymap = -- Raise
    [ ("l",   runOrRaiseNext "librewolf" (className =? "LibreWolf")) -- Librewolf
    , ("e",   raiseNext (className =? "Emacs")) -- Emacs cycle
    , ("s",   runOrRaise "Slack" (className =? "Slack")) -- Slack
    ]

-- Grid Select
gridselectKeymap = -- Grid Select
    [ ("t", promptedGoto  ) -- Workspace GS
    , ("l",   layoutGridSelect) -- Layout GS
    , ("h",   goToSelected $ mygridConfig myColorizer) -- Window GS
    , ("S-h",   bringSelected $ mygridConfig myColorizer) -- Bring GS
    , ("s",   getScratchpad) -- Scratchpads
    , ("S-t",  promptedShift) -- Shift Window to Selected GS
    , ("j",  spawnSelected' gsCategories) -- Category GS
    , ("k",  spawnSelected' $ gsGames ++ gsEducation ++ gsInternet ++ gsMultimedia ++ gsSystem ++ gsUtilities) -- App GS
    ]

-- Grid Select
scriptKeymap = -- Scripts
    [ ("h", spawn("~/bin/tabbed_zathura")) --Zathura
    , ("d", spawn("~/bin/do_not_disturb.sh")) -- Do Not Disturb
    , ("z", spawn("~/bin/inhibit_activate")) -- Inhibitor On
    , ("b",  spawn("~/bin/inhibit_deactivate")) -- Inhibitor Off
    ]


-- M4-S-m to get a menu of this in the dzen popup.  Comment is menu entry if present code otherwise.
mainKeymap c = mkKeymap c $ -- Main Keys
    [ ("M4-S-m",          toSubmap c "mainKeymap" []) -- Toggle WhichKey
    , ("M4-S-<Return>",     spawn myTerminal) -- Terminal
    , ("M4-S-c",        kill) -- Kill window
    , ("M4-<Backspace>", withFocused hideWindow) -- Hide
    , ("M4-S-<Backspace>", popOldestHiddenWindow) -- Unhide
    , ("M4-Insert",     pasteSelection) -- Paste selection
    , ("M4-<Space>",    sendMessage NextLayout) -- Next Layout
--    , ("M4-S-l",        myLayoutPrompt) -- Layout prompt
    , ("M4-j",          windows W.focusDown) --Focus Down
    , ("M4-k",          windows W.focusUp) --Focus Up
    , ("M4-S-j",        windows W.swapUp) -- Swap Up
    , ("M4-S-k",        windows W.swapDown) -- Swap Down
    , ("M4-<Tab>",      windows W.focusDown) -- Next Window
    , ("M4-S-<Tab>",    windows W.focusUp) -- Prev Window
    , ("M-S-w", selectWindow emConf >>= (`whenJust` windows . W.focusWindow)) --Window Select
-- prompted things
    -- tend to use "i" instead
    , ("M4-C-m",        manPrompt myXPConfig) -- Man Pages

    -- Sink
    -- , ("M4-r",   withFocused $ windows . W.sink) -- sink focused window
    , ("M4-S-r", sinkAll) -- sink all windows

    , ("M4-h",          sendMessage Shrink) -- Shrink
    , ("M4-l",          sendMessage Expand) -- Expand
    , ("M4-S-b",        sendMessage ToggleStruts) -- Toggle Struts

 -- recompile/reload - Quit
    , ("M4-q",          spawn "xmonad --recompile; xmonad --restart") -- Restart
    , ("M4-S-q",        io $ exitWith ExitSuccess) -- Quit

-- Submaps
    , ("M4-c",          toSubmap c "raiseKeymap" raiseKeymap) -- Raise
    , ("M4-b",          toSubmap c "bspKeymap" bspKeymap) -- BSP
    , ("M4-p",          toSubmap c "promptsKeymap" promptsKeymap) -- Prompts
    , ("M4-g",          toSubmap c "gridselectKeymap" gridselectKeymap) -- Grid Select
    , ("M4-e",          toSubmap c "namedScratchpadsKeymap" namedScratchpadsKeymap) -- Scratchpad
    , ("M4-o",          toSubmap c "rofiKeymap" rofiKeymap) -- Rofi
    , ("M4-m",          toSubmap c "tagWindowKeymap" tagWindowKeymap) -- tagged windows
    , ("M4-a",          toSubmap c "masterKeymap" masterKeymap) -- master pane
    , ("M4-f",          toSubmap c "focusKeymap" focusKeymap) -- Focus
    , ("M4-u",          toSubmap c "floatKeymap" floatKeymap) -- Float
    , ("M4-w",          toSubmap c "workspacesKeymap" workspacesKeymap) -- Workspaces
    -- , ("M4-S-l",          toSubmap c "layoutKeymap" layoutKeymap) -- Layout
    , ("M4-n",          toSubmap c "ewwKeymap" ewwKeymap) -- Eww Configs
    , ("M4-x",          toSubmap c "scriptKeymap" scriptKeymap) -- Scripts Launcher
    -- , ("M4-m",          toSubmap c "musicKeymap" musicKeymap) -- Music
    , ("M4-S-/",        toSubmap c "selectSearchKeymap" selectSearchKeymap) -- Select Search
        -- Here we see how submap keys work
        -- we add the key to look for, then the submap.
-- screenshots
    , ("M4-S-s",        toSubmap c "shotKeymap" shotKeymap) -- ScreenShot

-- dzen prompt search
   , ("M4-/",          toSubmap c "promptSearchKeymap" promptSearchKeymap) -- Prompt Search

    -- dont really like this, going to to the prompt in the browser.

-- keyboardless needs
    , ("M4-S-o",        spawn "onboard") -- onboard keyboard.
    ]
    ++
    [("M-" ++ m ++ k, f i)
     | (i, k) <- zip (topicNames myTopics) (map show [1 .. 9 :: Int])
    , (f, m) <- [(goto, ""), (windows . W.shift, "S-")]
    ]
   ++
-- -- Move Xinerema with xK_w keys
    [("M4-", f sc)
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, mask) <- [(viewScreen def, ""), (sendToScreen def, "S-")]]
--
------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


-- ###################################
-- ########  Startup hook   ##########
-- ###################################
-- By default, do nothing.
myStartupHook = do
  spawn "xsetroot -cursor_name left_ptr"
  -- spawn "exec ~/bin/lock.sh"
  -- spawnOnce "kmonad ~/.config/kmonad/config.kbd"
  spawnOnce "feh --bg-scale ~/wallpapers/gojo2.png"
  -- spawnOnce "picom"
  -- spawnOnce "greenclip daemon"
  -- spawnOnce "dunst"
  -- spawnOnce "exec ~/.config/polybar/launch.sh --cuts"

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.

-- fadeinactive = fadeInactiveLogHook fadeAmount
   -- where fadeAmount = 0.7

main = do
    dbus <- D.connect
    D.requestAccess dbus
    forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do
     safeSpawn "mkfifo" ["/tmp/" ++ file]


    xmonad $ Hacks.javaHack $ fullscreenSupport $ docks $ ewmh $ withSB myPolybar $ def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myTopicNames, -- Note, add when done configuring topic dirs
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
      -- key bindings
        keys               = mainKeymap,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        manageHook = myManageHook,
        layoutHook = myLayout, -- <$>myLayout
        handleEventHook    =  swallowEventHook (className =? "alacritty" <||> className =? "Termite") (return True)<+>fullscreenEventHook,
        logHook            =  dynamicLogWithPP (myLogHook dbus) <+> myEventHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }
