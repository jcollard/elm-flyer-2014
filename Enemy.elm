module Enemy where

import Util (..)
import Object (..)
import PowerUp (PowerUp)
import Missile.SplitShot (splitshotPowerUp)

type AdditionalTraits = { health : Int
                        , time : Time
                        , loot : Location -> [PowerUp]
                        }

type EnemyTraits = Traits AdditionalTraits

type Enemy = Object AdditionalTraits {}

enemy : { pos : Location, dim : Dimension, form : Form, health : Int } -> Enemy
enemy {pos, dim, form, health} =
    let traits = { pos = pos
                 , dim = dim
                 , form = form
                 , health = health
                 , time = 0
                 , destroyed = False
                 , loot = (\ pos -> [] )
                 }
    in object traits

checkDestroyed : EnemyTraits -> EnemyTraits
checkDestroyed traits =
    if | traits.health <= 0 -> { traits | destroyed <- True }
       | outOfBounds traits -> { traits | destroyed <- True }
       | otherwise -> traits
          


outOfBounds : EnemyTraits -> Bool
outOfBounds traits  =
    let objRight = traits.pos.x + (traits.dim.width / 2)
        objTop = traits.pos.y + (traits.dim.height / 2)
        objBot = traits.pos.y - (traits.dim.height / 2)
    in (objRight < screenBounds.left - 200) 
       || (objBot > screenBounds.top + 200) 
       || (objTop < screenBounds.bottom - 200)