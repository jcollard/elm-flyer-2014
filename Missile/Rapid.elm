module Missile.Rapid where

import Util (..)
import Object (..)
import Missile (..)
import PowerUp
import PowerUp (PowerUp, defaultPowerUp)

width : number
width = 10

height : number
height = 10

img : Form
img = toForm (image width width "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let m =  missile { defaultTraits |
                       pos <- pos
                     , dim <- { width = width, height = height }
                     , form <- img
                     , damage <- 5
                     , cooldown <- 15 }
        create_missile t = { m | passive <- passiveBuilder <| passive pos t }
    in map create_missile [0..2]

passive : Location -> Time -> Time -> MissileTraits -> MissileTraits
passive { x, y } modifier dt traits = 
    let t = traits.time 
        t_mod = t - modifier
        t' = t + dt
        x' = x + (t_mod/2)^2
        pos' = { x = x', y = y }
    in { traits | time <- t', 
                  pos <- pos'
       }

powerupImage : Form
powerupImage = toForm (image 42 42 "../assets/rapid-fire-power-up.png")

powerup : PowerUp
powerup = 
    PowerUp.powerup { defaultPowerUp | 
                      powerup <- fire
                    , form <- powerupImage
                    }