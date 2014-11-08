module State where

type State = Int

type Position = { x : Float, y : Float }
type BoundingBox = { x : Float, y : Float, width : Float, height : Float }

type Object a = { pos : Position, box : BoundingBox }

initialState : State
initialState = 0