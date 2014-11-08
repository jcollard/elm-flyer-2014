module Render where

import State

type State = State.State 

render : State -> [Form]
render state =  backdrop :: renderObject state.player :: (map renderObject state.objects)

renderObject : State.Object a -> Form
renderObject { pos, form } = move (pos.x, pos.y) form

backdrop : Form
backdrop = rect 1000 500 |> filled black
