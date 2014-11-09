module Physics where

import Object (..)
import State
import Enemy
import Missile

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let player' = updateObject state.player
        projectiles' = map updateObject state.projectiles
        enemies' =  map updateObject state.enemies
    in {state | player <- player', 
                projectiles <- projectiles', 
                enemies <- enemies'}

updateObject : Object a b -> Object a b
updateObject o =
    let traits = o.traits 
        traits' = { traits | pos <- pos (traits.pos.x + traits.vel.x) (traits.pos.y + traits.vel.y) }
    in tick { o | traits <- traits' }