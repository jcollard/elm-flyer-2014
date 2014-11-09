module Player where

import Playground.Input (..)
import Object (..)
import Missile (Missile)
import Missile
import Missile.Standard
import Keyboard.Keys as Keys
import State.ScreenBounds (screenBounds)

type AdditionalTraits = { cooldown : Time, fire : Location -> [Missile] }

type PlayerTraits = Traits AdditionalTraits

type Player = Object AdditionalTraits {}

playerImage : Form
playerImage = toForm (image 100 57 "assets/space-ship.gif")

player : Player
player = 
    let p = object { pos = {x = -400, y = 0},
                     vel = {x = 0, y = 0},
                     dim = { width = 100, height = 57 },
                     form = playerImage,
                     fire = Missile.Standard.fire,
                     cooldown = 0
                   }
    in { p | passive <- passive }

acceleration = 0.75

move : Player -> Input -> Player
move player input = 
    let traits = player.traits
        traits' = 
            case input of
              Key k -> if | k `Keys.equals` Keys.d ->
                           {traits | vel <- { x = acceleration + traits.vel.x, y = traits.vel.y } }
                          | k `Keys.equals` Keys.a ->
                            {traits | vel <- { x = traits.vel.x - acceleration, y = traits.vel.y } }
                          | k `Keys.equals` Keys.w ->
                            {traits | vel <- { x = traits.vel.x, y = acceleration + traits.vel.y } }
                          | k `Keys.equals` Keys.s ->
                            {traits | vel <- { x = traits.vel.x, y = traits.vel.y - acceleration } }
                          | otherwise -> traits
              otherwise -> traits
    in { player | traits <- traits' }

fire : Player -> [Missile]
fire { traits } = 
    if traits.cooldown > 0 then [] else traits.fire { x = traits.pos.x + traits.dim.width/2, y = traits.pos.y }


passive : PlayerTraits -> PlayerTraits
passive traits = { traits | vel <- { x = reduce traits.vel.x, y = reduce traits.vel.y },
                            pos <- keepOnScreen traits,
                            cooldown <- max 0 (traits.cooldown - 1) }

keepOnScreen : PlayerTraits -> Location
keepOnScreen { dim, pos } = 
    let leftEdge = pos.x - dim.width/8
        x' = if leftEdge >= screenBounds.left then pos.x else screenBounds.left + dim.width/8
        rightEdge = x' + dim.width/8
        x'' = if rightEdge <= screenBounds.right then x' else screenBounds.right - dim.width/8
        topEdge = pos.y + dim.height/8
        y' = if topEdge <= screenBounds.top then pos.y else screenBounds.top - dim.height/8
        bottomEdge = y' - dim.height/8
        y'' = if bottomEdge >= screenBounds.bottom then y' else screenBounds.bottom + dim.height/8
    in { x = x'', y = y'' }

reduce : Float -> Float
reduce x = if | abs x <= 0.01 -> 0
              | otherwise -> x/1.1