module Render where

import SFX
import Util (..)
import Playground (..)
import Playground.Input (..)
import State (State)
import Object (..)
import Debug 

render : RealWorld -> State -> [Form]
render rw state = [ background state.time
                  , renderObject state.player
                  , group <| map renderObject state.projectiles
                  , group <| map renderObject state.enemies
                  , group <| map SFX.render state.sfxs
                  , group <| ui rw
                  , group <| menu state
                  , group <| paused state
                  , group <| gameover state
                  , group <| livesRemaining state
                  ]

liveImage = toForm (image 28 50 "assets/space-ship-vert.png")

livesRemaining : State -> [Form]
livesRemaining state =
    let lives = state.player.traits.lives
    in if | lives < 1 -> []
       | otherwise ->
           let pos = (-450, -200)
               form n = move pos << move (n*30, 0) <| liveImage
           in map form [0..(lives-2)]

pausedImage = toForm (image 1000 500 "assets/paused.png")
menuImage = toForm (image 1000 500 "assets/menu.png")
gameOverImage = toForm (image 1000 500 "assets/game_over.png")

gameover : State -> [Form]
gameover state =
    if | state.menu -> []
       | not state.gameover -> []
       | otherwise -> [gameOverImage]

paused : State -> [Form]
paused state =
    if | state.menu -> []
       | not state.paused -> []
       | otherwise -> [pausedImage]

menu : State -> [Form]
menu state =
    if | not state.menu -> []
       | otherwise -> [menuImage]

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
