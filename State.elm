module State where

type State = { player : Object {}, objects : [Object {}] }

type Position = { x : Float, y : Float }
type BoundingBox = { x : Float, y : Float, width : Float, height : Float }

type Object a = { pos : Position, box : BoundingBox, form : Form }

initialState : State
initialState = { player = player, objects = [initialObject] }

initialObject = { pos = { x = 0, y = 0 },
                  box = { x = -10, y = -10, width = 20, height = 20 },
                  form = circle 50 |> filled blue }

player = { pos = {x = -20, y = 100},
           box = { x = -20, y = -25, width = 40, height = 50 },
           form = rect 40 50 |> filled red }
