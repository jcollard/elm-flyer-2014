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
                            cooldown = 100 }
        traits = missile.traits
    in [{ missile | passive <- passive },
        { missile | passive <- passive, traits <- {traits | time <- -1} },
        { missile | passive <- passive, traits <- {traits | time <- -2} },
        { missile | passive <- passive, traits <- {traits | time <- -3} },
        { missile | passive <- passive, traits <- {traits | time <- -4} },
        { missile | passive <- passive, traits <- {traits | time <- -5} },
        { missile | passive <- passive, traits <- {traits | time <- -6} },
        { missile | passive <- passive, traits <- {traits | time <- -7} },
        { missile | passive <- passive, traits <- {traits | time <- -8} },
        { missile | passive <- passive, traits <- {traits | time <- -9} },
        { missile | passive <- passive, traits <- {traits | time <- -10} }]

passive : Time -> MissileTraits -> MissileTraits
passive dt traits = 
    let t = traits.time 
        t' = t + dt
        vel' = { x = t/2, y = 15 * (cos << degrees <| 9*t) }
        dim' = { width = 2*t, height = 2*t }
        form' = toForm (image (round dim'.width) (round dim'.height) "../assets/standard-missile.gif")
    in if t < 0 then { traits | time <- t' } else
           Debug.watch "Missile Traits" 
                    { traits | time <- t', 
                               vel <- vel',
                               dim <- dim',
                               form <- form'
                    }
