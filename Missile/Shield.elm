module Missile.Shield where

import Util (..)
import Object (..)
import Missile (..)
import Debug


width : number
width = 25

height : number
height = 100

img : Form
img = toForm (image width height "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let m =  missile { defaultTraits | 
                       dim <- { width = width, height = height }
                     , pos <- pos
                     , form <- img
                     , damage <- 5
                     , cooldown <- 200 }
    in map (\ _ -> { m | passive <- passiveBuilder (passive pos) }) [1..20]

passive : Location -> Time -> MissileTraits -> MissileTraits
passive {x, y} dt traits = 
    let t = traits.time 
        t' = t + dt
        pos' = { x = x + t, y = y }
    in { traits | time <- t' 
                , pos <- pos'
       }
