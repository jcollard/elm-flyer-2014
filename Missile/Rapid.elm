module Missile.Rapid where

import Util (..)
import Object (..)
import Missile (..)
import PowerUp
import PowerUp (PowerUp, defaultPowerUp)

width : number
width = 5

height : number
height = 5

img : Form
img = toForm (image width width "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let m =  missile { defaultTraits |
                       pos <- pos
                     , dim <- { width = width, height = height }
                     , form <- img
                     , damage <- 5
                     , cooldown <- 0 }
    in [{ m | passive <- passiveBuilder <| passive pos }]

passive : Location -> Time -> MissileTraits -> MissileTraits
passive { x, y } dt traits = 
    let t = traits.time 
        t' = t + dt
        pos' = { x = x + (t/2)^(2), y = y }
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