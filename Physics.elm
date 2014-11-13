module Physics where

import Object (..)
import State
import Enemy
import Missile

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let t = dt/17
        player' = tick t state.player
        projectiles' = map (tick t) state.projectiles
        enemies' =  map (tick t) state.enemies
    in {state | player <- player', 
                projectiles <- projectiles', 
                enemies <- enemies'}

