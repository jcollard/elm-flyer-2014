module Enemy where

import Util (..)
import Object (..)

type AdditionalTraits = { health : Int,
                          time : Time }

type EnemyTraits = Traits AdditionalTraits

type Enemy = Object AdditionalTraits {}

enemy : { pos : Location, dim : Dimension, form : Form, health : Int } -> Enemy
enemy {pos, dim, form, health} =
    let traits = { pos = pos,
                   dim = dim,
                   form = form,
                   health = health,
                   time = 0,
                   destroyed = False }
    in object traits

checkDestroyed : EnemyTraits -> EnemyTraits
checkDestroyed traits =
    if | traits.health > 0 -> traits
       | outOfBounds traits -> { traits | destroyed <- True }
       | otherwise -> { traits | destroyed <- True }
          


outOfBounds : EnemyTraits -> Bool
outOfBounds traits  =
    let objLeft = traits.pos.x - (traits.dim.width / 2)
        objRight = traits.pos.x + (traits.dim.width / 2)
        objTop = traits.pos.y + (traits.dim.height / 2)
        objBot = traits.pos.y - (traits.dim.height / 2)
    in (objRight < screenBounds.left - 200) 
       || (objLeft > screenBounds.right + 1000) 
       || (objBot > screenBounds.top + 200) 
       || (objTop < screenBounds.bottom - 200)