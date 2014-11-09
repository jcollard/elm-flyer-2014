module Player where

import Playground.Input (..)
import Object (..)
import Missile (Missile)
import Missile
import Missile.Standard
import Keyboard.Keys as Keys

type AdditionalTraits = { cooldown : Time, fire : Location -> [Missile] }

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

move : Player -> Input -> Player
move player input = 
    let traits = player.traits
        traits' = 
            case input of
              Key k -> if | k `Keys.equals` Keys.d ->
                           {traits | vel <- { x = 2, y = traits.vel.y } }
                          | k `Keys.equals` Keys.a ->
                            {traits | vel <- { x = -2, y = traits.vel.y } }
                          | k `Keys.equals` Keys.w ->
                            {traits | vel <- { x = traits.vel.x, y = 2 } }
                          | k `Keys.equals` Keys.s ->
                            {traits | vel <- { x = traits.vel.x, y = -2 } }
                          | otherwise -> traits
              otherwise -> traits
    in { player | traits <- traits' }

fire : Player -> [Missile]
fire { traits } = traits.fire { x = traits.pos.x + traits.dim.width/2, y = traits.pos.y }
--    if traits.cooldown > 0 then [] else traits.fire { x = traits.pos.x + traits.dim.width/2, y = traits.pos.y }


passive : Traits a -> Traits a
passive traits = { traits | vel <- { x = 0, y = 0 } }