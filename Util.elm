module Util where

type Location = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type Dimension = { width : Float, height : Float }

screenBounds = {left = -500, right = 500, top = 250, bottom = -250,
                width = 1000, height = 500}
