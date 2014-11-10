module Missile.Standard where

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
    let missile =  object { pos = pos,
                            dim = { width = width, height = height },
                            vel = { x = 0, y = 0 },
                            form = img,
                            time = 0,
                            damage = 5,
                            cooldown = 15 }
    in [{ missile | passive <- passive }]

passive : Time -> MissileTraits -> MissileTraits
passive dt traits = 
    let t = traits.time 
        t' = t + dt
        vel' = { x = min t 15, y = 0 }
    in { traits | time <- t', 
                  vel <- vel'
       }
