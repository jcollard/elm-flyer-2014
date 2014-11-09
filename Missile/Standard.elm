module Missile.Standard where

import Object (..)
import Missile (..)

width = 25
height = 25

img = toForm (image width width "../assets/standard-missile.gif")

spawn : Location -> [Missile]
spawn pos = 
    let traits = {pos = pos,
                  dim = {width = width, height = height},
                  vel = {x = 0, y = 0},
                  form = img,
                  time = 0,
                  damage = 5,
                  cooldown = 15 }
    in [{ traits = traits, passive = passive }]

passive : MissileTraits -> MissileTraits
passive traits = 
    let t = traits.time 
        t' = t + 1
        vel' = { x = min t 15, y = 0 }
    in { traits | time <- t', 
                  vel <- vel'
       }
