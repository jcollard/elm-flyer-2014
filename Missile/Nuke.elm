module Missile.Nuke where

import Object (..)
import Missile (..)
import Debug

img : Form
img = toForm (image 0 0 "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let missile =  object { pos = pos,
                            dim = { width = 0, height = 0 },
                            vel = { x = 0, y = 0 },
                            form = img,
                            time = 0,
                            damage = 5,
                            cooldown = 150 }
        traits = missile.traits
    in [ { missile | passive <- passive } ]

passive : Time -> MissileTraits -> MissileTraits
passive dt traits = 
    let t = traits.time 
        t' = t + dt
        vel' = { x = 3, y = 10 * (cos << degrees <| 5*t) }
        dim' = { width = t, height = t }
        form' = toForm (image (round dim'.width) (round dim'.height) "../assets/standard-missile.gif")
    in { traits | time <- t', 
                  vel <- vel',
                  dim <- dim',
                  form <- form'
                    }
