module Player where

import Playground.Input (..)
import Object (..)
import Missile (Missile)
import Missile
import Missile.Standard
import Keyboard.Keys as Keys

playerImage = toForm (image 100 57 "assets/space-ship.gif")

type Player = Object { fire : Location -> [Missile],
                       cooldown : Time }

player : Player
player = { pos = {x = -400, y = 0},
           vel = {x = 0, y = 0},
           dim = { width = 100, height = 57 },
           form = playerImage,
           fire = Missile.Standard.spawn,
           cooldown = 0,
           passive = passive
         }

move : Player -> Input -> Player
move player input = case input of
    Key k -> if | k `Keys.equals` Keys.d ->
                    {player | vel <- { x = 2, y = player.vel.y } }
                | k `Keys.equals` Keys.a ->
                    {player | vel <- { x = -2, y = player.vel.y } }
                | k `Keys.equals` Keys.w ->
                    {player | vel <- { x = player.vel.x, y = 2 } }
                | k `Keys.equals` Keys.s ->
                    {player | vel <- { x = player.vel.x, y = -2 } }
                | otherwise -> player
    otherwise -> player

fire : Player -> [Missile]
fire { pos, dim, fire, cooldown } = 
    if cooldown > 0 then [] else fire { x = pos.x + dim.width/2, y = pos.y }

passive : Time -> Velocity
passive t = { x = 0, y = 0 }

handleAction : Player -> Player
handleAction p =
    { p | vel <- p.passive 0 }