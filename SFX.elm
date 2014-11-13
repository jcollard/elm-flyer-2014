module SFX where

import Util (..)

type SFX = { pos : Location
           , time : Time
           , duration : Time
           , sfx : Time -> Form }

render : SFX -> Form
render { pos, time, sfx } = sfx time |> move (pos.x, pos.y)