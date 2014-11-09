module Enemy where

import Object (..)

type Enemy = Object { 
      health : Int,
      time : Time,
      action : Time -> Velocity
                    }

handleAction : Enemy -> Enemy
handleAction enemy =
    { enemy | time <- enemy.time + 1,
              vel <- enemy.action enemy.time }