module Object where

type Location = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type Dimension = { width : Float, height : Float }

type Traits a = { a | pos : Location,
                      dim : Dimension,
                      form : Form}

type Object a b = { b | traits : Traits a,
                        passive : Time -> Traits a -> Traits a,
                        render : Traits a -> Form }

tick : Time -> Object a b -> Object a b
tick t object = { object | traits <- object.passive t object.traits }

object : Traits a -> Object a {}
object traits =
    { traits = traits,
      passive = passive,
      render = render }

passive : Time -> Traits a -> Traits a
passive t ts = ts

render : Traits a -> Form
render { pos, form} = move (pos.x, pos.y) form