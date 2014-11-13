module Missile.SplitShot where

import Object (..)
import Missile (..)
import Debug


width : number
width = 15

height : number
height = 15

img : Form
img = toForm (image width width "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let missile =  object { defaultTraits |
                            dim <- { width = width, height = height }
                          , pos <- pos
                          , form <- img
                          , damage <- 5
                          , cooldown <- 15 
                          }
    in [{ missile | passive <- passiveBuilder <| passive pos 1 },
        { missile | passive <- passiveBuilder <| passive pos (-1) }]

passive : Location -> Float -> Time -> MissileTraits -> MissileTraits
passive { x, y } modifier dt traits = 
    let t = traits.time 
        t' = t + dt
        distance = 10
        x' = x + (t/2)^2
        y' = if t < 15 then y else y + modifier * (t - 15)^(1.4)
        pos' = { x = x', y = y' }
    in { traits |
         time <- t'
       , pos <- pos'                         
       }
