module Update where
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State

type State = State.State

update : RealWorld -> Input -> State -> State
update rw input state = 
    case input of
      Key k -> if | k `Keys.equals` Keys.arrowUp -> state + 1
                  | k `Keys.equals` Keys.arrowDown -> state - 1
                  | otherwise -> state
      otherwise -> state