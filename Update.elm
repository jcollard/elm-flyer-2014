module Update where
import Object (..)
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State (..)

import Player
import Physics

update : RealWorld -> Input -> State -> State
update rw input state = case input of
    Passive t -> (cleanUp << Physics.physics t) state
    otherwise ->  
        let player' = Player.move state.player input
            state' = handleFire input state
        in { state' | player <- player' }



handleFire : Input -> State -> State
handleFire input state = 
    case input of
      Tap k -> if | k `Keys.equals` Keys.space -> 
                    let ps = Player.fire state.player
                    in { state | projectiles <- ps ++ state.projectiles }
                  | otherwise -> state
      otherwise -> state


cleanUp : State -> State
cleanUp state =
    let pps = filter (not << outOfBounds) state.projectiles
        objs = filter (not << outOfBounds) state.enemies
    in {state | projectiles <- pps, enemies <- objs}

outOfBounds : Object a -> Bool
outOfBounds obj =
    let objLeft = obj.pos.x - (obj.dim.width / 2)
        objRight = obj.pos.x + (obj.dim.width / 2)
        objTop = obj.pos.y + (obj.dim.height / 2)
        objBot = obj.pos.y - (obj.dim.height / 2)
    in (objRight < screenBounds.left) || (objLeft > screenBounds.right) ||
        (objBot > screenBounds.top) || (objTop < screenBounds.bottom)
