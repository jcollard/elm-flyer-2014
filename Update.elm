module Update where
import Object (..)
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State (..)
import Debug

import Player
import Physics

update : RealWorld -> Input -> State -> State
update rw input state = 
    let player = Debug.watch "Player" (state.player) in
    case input of
      Passive t -> (cleanUp << Physics.physics t) state
      otherwise ->  
        let state' = handleFire input state
            player' = Player.move state'.player input
        in { state' | player <- player' }


handleFire : Input -> State -> State
handleFire input state = 
    case input of
      Tap k -> if | k `Keys.equals` Keys.space -> 
                    let ps = Player.fire state.player
                        player = state.player
                        traits = player.traits
                        cooldown' = if isEmpty ps 
                                    then traits.cooldown
                                    else (head ps).traits.cooldown
                        traits' = { traits | cooldown <- cooldown' }
                        player' = { player | traits <- traits' }
                    in { state | projectiles <- ps ++ state.projectiles,
                                 player <- Debug.watch "Player" player' }
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
