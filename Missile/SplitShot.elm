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
    let missile =  object { pos = pos,
                            dim = { width = width, height = height },
                            vel = { x = 0, y = 0 },
                            form = img,
                            time = 0,
                            damage = 5,
                            cooldown = 15 }
    in [{ missile | passive <- passive 1 },
        { missile | passive <- passive (-1) }]

passive : Float -> MissileTraits -> MissileTraits
passive modifier traits = 
    let t = traits.time 
        t' = t + 1
        distance = 10
        vel' = { x = min t 15, y = if t <= distance then 0 else modifier * (min (t - distance) 5) }
    in { traits | time <- t', 
                  vel <- vel'
       }
