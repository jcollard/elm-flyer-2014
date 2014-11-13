module Missile.Nuke where

import PowerUp
import PowerUp (PowerUp, defaultPowerUp)

import Object (..)
import Util (..)
import Missile (..)
import Debug

img : Form
img = toForm (image 0 0 "../assets/standard-missile.gif")

fire : Location -> [Missile]
fire pos = 
    let m =  missile { defaultTraits |
                       pos <- pos
                     , dim <- { width = 0, height = 0 }
                     , form <- img
                     , damage <- 5
                     , cooldown <- 150 }
        traits = m.traits
        create_missile t = { m | passive <- passiveBuilder <| passive pos t }
    in map create_missile [0..19]

passive : Location -> Time -> Time -> MissileTraits -> MissileTraits
passive { x , y } modifier dt traits = 
    let t = traits.time 
        t_mod = t - modifier
        t' = t + dt
        x' = x + (t_mod*5)
        y' = y + t_mod*sin(degrees <| 5*t_mod)
        pos' = { x = x', y = y' }
        dim' = { width = max 0 t_mod, height = max 0 t_mod }
        form' = toForm (image (round dim'.width) (round dim'.height) "../assets/standard-missile.gif")
    in { traits | time <- t', 
                  pos <- pos',
                  dim <- dim',
                  form <- form'
                    }
powerupImage : Form
powerupImage = toForm (image 42 42 "../assets/nuke-power-up.png")

powerup : PowerUp
powerup = 
    PowerUp.powerup { defaultPowerUp | 
                      powerup <- fire
                    , form <- powerupImage
                    }