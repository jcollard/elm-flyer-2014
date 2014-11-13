module Missile.Standard where

import Util (..)
import Object (..)
import Missile (..)
import Debug


width : number
width = 25

height : number
height = 25

img : Form
img = toForm (image width width "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let m =  missile { defaultTraits | 
                       dim <- { width = width, height = height }
                     , pos <- pos
                     , form <- img
                     , damage <- 5
                     , cooldown <- 10 }
    in [{ m | passive <- passiveBuilder (passive pos) }]

passive : Location -> Time -> MissileTraits -> MissileTraits
passive {x, y} dt traits = 
    let t = traits.time 
        t' = t + dt
        pos' = { x = x + (t/2)^(2), y = y }
    in { traits | time <- t' 
                , pos <- pos'
       }
