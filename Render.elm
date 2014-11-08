module Render where

import State

type State = State.State 

render : State -> [Form]
render state = map renderObject state.objects

renderObject : State.Object a -> Form
renderObject { pos, form } = move (pos.x, pos.y) form