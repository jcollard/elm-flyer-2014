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
                   vel = { x = 0, y = 0 },
                   time = 0 }
    in object traits
          