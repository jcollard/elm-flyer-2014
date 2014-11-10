module Physics where

import Object (..)
import State
import Enemy
import Missile

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let t = dt/17
        player' = updateObject t state.player
        projectiles' = map (updateObject t) state.projectiles
        enemies' =  map (updateObject t) state.enemies
    in {state | player <- player', 
                projectiles <- projectiles', 
                enemies <- enemies'}

updateObject : Time -> Object a b -> Object a b
updateObject t o =
    let traits = o.traits 
        traits' = { traits | pos <- pos (traits.pos.x + t*traits.vel.x) (traits.pos.y + t*traits.vel.y) }
    in tick t { o | traits <- traits' }