module Render where

import Util (..)
import Playground (..)
import Playground.Input (..)
import State (State)
import Object (..)
import Debug 

render : RealWorld -> State -> [Form]
render rw state = (background state.time) :: 
                   renderObject state.player :: 
                  (map renderObject state.projectiles) ++ 
                  (map renderObject state.enemies) ++ 
                  (ui rw)

renderObject : Object a b -> Form
renderObject { traits } = 
    let pos = traits.pos 
        form = traits.form
    in move (pos.x, pos.y) form

backdrop start offset t =
    let xt = toFloat <| (round <| t + offset) % 4000
    in move (start - xt, 0) << toForm <| (image 2002 502 "assets/background-layer-0.png")

background : Time -> Form
background t = 
    let t' = t*5
    in group [backdrop 1500 0 t', backdrop 2500 3000 t']

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
