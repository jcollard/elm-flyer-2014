module Object where

type Location = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type Dimension = { width : Float, height : Float }

type Traits a = { a | pos : Location,
                      vel : Velocity,
                      dim : Dimension,
                      form : Form}

type Object a = { traits : Traits a,
                  passive : Traits a -> Traits a }

passive : Object a -> Object a
passive object = { object | traits <- object.passive object.traits }