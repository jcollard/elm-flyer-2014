module State where

type State = { objects : [Object {}] }

type Position = { x : Float, y : Float }
type BoundingBox = { x : Float, y : Float, width : Float, height : Float }

type Object a = { pos : Position, box : BoundingBox, form : Form }

initialState : State
initialState = { objects = [initialObject] }

initialObject = { pos = { x = 0, y = 0 }, 
                  box = { x = -10, y = -10, width = 20, height = 20 },
                  form = circle 50 |> filled blue }