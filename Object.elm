module Object where

import State.ScreenBounds (screenBounds)

type Location = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type Dimension = { width : Float, height : Float }

type Traits a = { a | pos : Location,
                      dim : Dimension,
                      form : Form,
                      destroyed : Bool }

type Object a b = { b | traits : Traits a,
                        passive : Time -> Traits a -> Traits a,
                        render : Traits a -> Form }

type BoundingBox = { left : Float
                   , right : Float
                   , top : Float
                   , bottom : Float }

boundingBox : { a | traits : { b | dim : Dimension
                                 , pos : Location }} -> BoundingBox
boundingBox o =
    let w = o.traits.dim.width/2
        h = o.traits.dim.height/2
    in { left = o.traits.pos.x - w
       , right = o.traits.pos.x + w
       , top = o.traits.pos.y + h
       , bottom = o.traits.pos.y - h }

intersect : Object a b -> Object c d -> Bool
intersect o0 o1 =
    let box0 = boundingBox o0
        box1 = boundingBox o1
    in not (box0.right < box1.left ||
            box0.left > box1.right ||
            box0.top < box1.bottom ||
            box0.bottom > box1.top)

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
