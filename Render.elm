module Render where

import Playground (..)
import Playground.Input (..)
import State (screenBounds, State, Object)

render : State -> [Form]
render state =  backdrop :: renderObject state.player :: (map renderObject
    state.playerProjectiles) ++ (map renderObject state.objects) ++ ui

renderObject : Object a -> Form
renderObject { pos, form } = move (pos.x, pos.y) form

backdrop : Form
backdrop = rect 1000 500 |> filled black

ui : RealWorld -> [Form]
ui rw =
    let width = rw.right * 2
        height = rw.top * 2
        topRect = rect width ((height - screenBounds.height) / 2)
        botRect = topRect
        leftRect = rect ((width - screenBounds.width) / 2) height
        rightRect = leftRect
        uiRects = [topRect, botRect, leftRect, rightRect]
        ui = map (filled blue) uiRects
    in zipWith move [(0, height / 2), (0, -height / 2),
                  (-width / 2, 0), (width / 2, 0)] ui
