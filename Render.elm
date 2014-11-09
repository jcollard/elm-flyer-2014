module Render where

import Playground (..)
import Playground.Input (..)
import State (screenBounds, State)
import Object (..)

render : RealWorld -> State -> [Form]
render rw state =  backdrop :: 
                   renderObject state.player :: 
                  (map renderObject state.projectiles) ++ 
                  (map renderObject state.enemies) ++ 
                  (ui rw)

renderObject : Object a -> Form
renderObject { pos, form } = move (pos.x, pos.y) form

backdrop : Form
backdrop = rect 1000 500 |> filled black

ui : RealWorld -> [Form]
ui rw =
    let width = rw.right * 2
        height = rw.top * 2
        topRectHeight = (height - screenBounds.height) / 2
        topRect = rect width topRectHeight
        botRect = topRect
        leftRectWidth = (width - screenBounds.width) / 2
        leftRect = rect leftRectWidth height
        rightRect = leftRect
        uiRects = [topRect, botRect, leftRect, rightRect]
        ui = map (filled blue) uiRects
    in zipWith move [(0, screenBounds.height/2 + topRectHeight/2), (0, -(screenBounds.height/2 + topRectHeight/2)),
                  (-(screenBounds.width/2 + leftRectWidth/2), 0), ((screenBounds.width/2 + leftRectWidth/2), 0)] ui
