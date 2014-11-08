module Update where
import Playground (..)
import Playground.Input (..)
import State

type State = State.State

update : RealWorld -> Input -> State -> State
update rw input state = state