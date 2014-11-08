module Physics where

import State
pos = State.Position

physics : Time -> State.State -> State.State
physics dt state =
    let player' = updateObject state.player
        projectiles' = map updateObject state.playerProjectiles
        objects' = map updateObject state.objects
    in {state | player <- player', playerProjectiles <- projectiles', objects
       <- objects'}

updateObject : State.Object a -> State.Object a
updateObject o = { o | pos <- pos (o.pos.x + o.vel.x) (o.pos.y + o.vel.y) }
