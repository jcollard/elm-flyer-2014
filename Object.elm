module Object where

type Location = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type Dimension = { width : Float, height : Float }

type Object a = { a | pos : Location, vel: Velocity,
                      dim : Dimension, form : Form }

