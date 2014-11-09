module Enemy where

import Object (..)

type AdditionalTraits = { health : Int,
                          time : Time }

type EnemyTraits = Traits AdditionalTraits

type Enemy = Object AdditionalTraits

spawn : { pos : Location,
          health : Int,
          dim : Dimension,
          form : Form,
          passive : EnemyTraits -> EnemyTraits } -> Enemy
spawn { pos, health, dim, form, passive } =
    let traits = 
            { pos = pos,
              vel = { x = 0, y = 0 },
              dim = dim,
              form = form,
              health = health,
              time = 0
            }
    in { traits = traits, passive = passive }
          