module Enemy where

import Object (..)

type Enemy = Object { 
      health : Int,
      time : Time,
      action : Time -> Velocity
                    }