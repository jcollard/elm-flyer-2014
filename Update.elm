module Update where
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State

type State = State.State

update : RealWorld -> Input -> State -> State
update rw input state = state