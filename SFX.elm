module SFX where

import Util (..)

type SFX = { pos : Location
           , time : Time
           , duration : Time
           , frame : Int
           , sfx : Time -> Int -> Form }

render : SFX -> Form
render { pos, time, sfx, frame } = sfx time frame |> move (pos.x, pos.y)

tick : Time -> SFX -> SFX
tick dt sfx = { sfx | 
                time <- sfx.time + dt
              , frame <- sfx.frame + 1
              }