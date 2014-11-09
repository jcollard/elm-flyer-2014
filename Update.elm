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
        in { state | player <- player' }


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

outOfBounds : Object a b -> Bool
outOfBounds { traits } =
    let objLeft = traits.pos.x - (traits.dim.width / 2)
        objRight = traits.pos.x + (traits.dim.width / 2)
        objTop = traits.pos.y + (traits.dim.height / 2)
        objBot = traits.pos.y - (traits.dim.height / 2)
    in (objRight < screenBounds.left - 200) 
       || (objLeft > screenBounds.right + 200) 
       || (objBot > screenBounds.top + 200) 
       || (objTop < screenBounds.bottom - 200)
