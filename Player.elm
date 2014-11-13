module Player where

import Array
import Playground.Input (..)
import Util (..)
import Object (..)

import Missile (Missile)

import SFX (SFX) 
import Missile
import Missile.Standard
import Missile.SplitShot
import Missile.Rapid
import Missile.Nuke
import Missile.Shield

import Keyboard.Keys as Keys

type AdditionalTraits = { cooldown : Time
                        , fire : Location -> [Missile]
                        , vel : Velocity
                        , lives : Int
                        , time : Time
                        }

type PlayerTraits = Traits AdditionalTraits

type Player = Object AdditionalTraits {}

playerImage : Form
playerImage = toForm (image 100 57 "assets/space-ship.gif")

spawnImage : Form
spawnImage = toForm (image 100 57 "assets/spawn-ship.gif")

hiddenImage : Form
hiddenImage = toForm (image 0 0 "assets/spawn-ship.gif")

explosion : Form
explosion = toForm (image 200 200 "assets/explosion.gif")

player : Player
player = 
    let p = object { pos = {x = -400, y = 0}
                   , vel = {x = 0, y = 0}
                   , dim = { width = 100, height = 57 }
                   , form = playerImage
-- Quick debug by uncommenting one of these
                   , fire = Missile.Standard.fire
                   , cooldown = 0
                   , lives = 3
                   , destroyed = False
                   , time = 0
                   }
    in { p | 
         passive <- passive
       , destroyedSFX <- destroyedSFX
       }

destroyedSFX : Traits a -> SFX
destroyedSFX { pos } =
    let frames = Array.initialize 18 (\f -> toForm (image 200 200 ("assets/explosion/" ++ show f ++ ".png")))
    in
       { pos = pos
       , time = 0
       , duration = 1000
       , sfx = (\t f -> Array.getOrFail (min 17 f) frames)
       , frame = 0
       }

acceleration = 0.75

move : Player -> Input -> Player
move player input = 
    let traits = player.traits
        traits' = 
            case input of
              Key k -> if | k `Keys.equals` Keys.arrowRight ->
                           {traits | vel <- { x = acceleration + traits.vel.x, y = traits.vel.y } }
                          | k `Keys.equals` Keys.arrowLeft ->
                            {traits | vel <- { x = traits.vel.x - acceleration, y = traits.vel.y } }
                          | k `Keys.equals` Keys.arrowUp ->
                            {traits | vel <- { x = traits.vel.x, y = acceleration + traits.vel.y } }
                          | k `Keys.equals` Keys.arrowDown ->
                            {traits | vel <- { x = traits.vel.x, y = traits.vel.y - acceleration } }
                          | k `Keys.equals` Keys.one ->
                            { traits | fire <- Missile.SplitShot.fire }
                          | k `Keys.equals` Keys.two ->
                            { traits | fire <- Missile.Rapid.fire }
                          | k `Keys.equals` Keys.three ->
                            { traits | fire <- Missile.Nuke.fire }
                          | k `Keys.equals` Keys.four ->
                            { traits | fire <- Missile.Standard.fire }
                          | k `Keys.equals` Keys.five ->
                            { traits | fire <- Missile.Shield.fire }
                          | otherwise -> traits
              otherwise -> traits
    in { player | traits <- traits' }

fire : Player -> [Missile]
fire { traits } = 
    if | (traits.cooldown > 0 ||
          traits.time < 0     ||
          traits.lives < 1      )-> [] 
       | otherwise -> traits.fire { x = traits.pos.x + traits.dim.width/2, y = traits.pos.y }


passive : Time -> PlayerTraits -> PlayerTraits
passive dt traits = 
    let 
        x' = if | traits.time < -100 -> -400
                | otherwise -> traits.pos.x + traits.vel.x*dt
        y' = if | traits.time < -100 -> 0 
                | otherwise -> traits.pos.y + traits.vel.y*dt
        traits' = { traits | pos <- { x = x', y = y' }}
        form' = if | traits.lives < 1 -> hiddenImage
                   | traits.time < -100 -> hiddenImage
                   | traits.time < 0 -> spawnImage
                   | otherwise -> playerImage
    in { traits' | 
         vel <- { x = reduce traits.vel.x, y = reduce traits.vel.y }
       , pos <- keepOnScreen traits'
       , cooldown <- max 0 (traits.cooldown - dt)
       , time <- traits.time + dt
       , form <- form'
       }

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