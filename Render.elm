module Render where

import State

type State = State.State

render : State -> [Form]
render state = [toForm << asText <| state]