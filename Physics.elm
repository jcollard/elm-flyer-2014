module Physics where

import Object (..)
import State

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let player' = updateObject state.player
        projectiles' = map updateObject state.projectiles
        enemies' = map updateObject state.enemies
    in {state | player <- player', 
                projectiles <- projectiles', 
                enemies <- enemies'}

updateObject : Object a -> Object a
updateObject o = { o | pos <- pos (o.pos.x + o.vel.x) (o.pos.y + o.vel.y) }
