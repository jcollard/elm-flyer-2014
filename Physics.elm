module Physics where

import SFX

import Util (..)
import Object (..)
import State

import Enemy
import Enemy (Enemy)

import Missile
import Missile (Missile)

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let t = dt/17
        player' = tick t state.player
        projectiles' = map (tick t) state.projectiles
        enemies' =  map (tick t) state.enemies
        (projectiles'', enemies'') = checkHits projectiles' enemies'
        sfxs' = map (SFX.tick dt) state.sfxs
    in {state | player <- player', 
                projectiles <- projectiles'', 
                enemies <- enemies'',
                sfxs <- sfxs'}

checkHits : [Missile] -> [Enemy] -> ([Missile], [Enemy])
checkHits = checkHits' []

checkHits' : [Missile] -> [Missile] -> [Enemy] -> ([Missile], [Enemy])
checkHits' acc_ms ms es =
    case ms of
      [] -> (acc_ms, reverse es)
      (m::ms') ->
          if | m.traits.destroyed -> checkHits' (m::acc_ms) ms' es
             | otherwise ->
                 let (hit, es') = checkHitEnemy m es
                 in if
                     -- If hit, mark missile destroyed
                     | hit -> 
                         let mtraits = m.traits
                             m' = { m | traits <- { mtraits | destroyed <- True } }
                         in checkHits' (m'::acc_ms) ms' es'
                     -- Otherwise keep it
                     | otherwise -> checkHits' (m::acc_ms) ms' es'

checkHitEnemy : Missile -> [Enemy] -> (Bool, [Enemy])
checkHitEnemy = checkHitEnemy' []

checkHitEnemy' : [Enemy] -> Missile -> [Enemy] -> (Bool, [Enemy])
checkHitEnemy' acc m es =
    case es of
      [] -> (False, acc)
      (e::es') -> if 
                    -- If the Enemys health is less than 1, skip it
                    | e.traits.health <= 0 -> checkHitEnemy' (e::acc) m es'
                    -- If the Missile doesn't hit the enemy, continue down the list
                    | not <| intersect m e -> checkHitEnemy' (e::acc) m es'
                    -- If the Missle does hit the enemy, reduce the enemies health by the damage amount of the Missile.
                    | otherwise -> 
                        let traits = e.traits
                            e' = { e | traits <- { traits | health <- traits.health - m.traits.damage } }
                        in (True, es' ++ (e' :: acc))
