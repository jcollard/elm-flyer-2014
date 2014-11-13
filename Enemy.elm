module Enemy where

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
       | otherwise -> { traits | destroyed <- True }
          