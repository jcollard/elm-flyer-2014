module Physics where

import SFX

import Util (..)
import Object (..)
import State

import PowerUp (PowerUp)

import Enemy
import Enemy (Enemy)

import Missile
import Missile (Missile)

import Player (Player)

import Debug

pos = Location

physics : Time -> State.State -> State.State
physics dt state = 
    let t = dt/17
        player' = tick t (checkPlayerHit state.player state.enemies)
        powerups' = map (tick t) state.powerups
        (player'', powerups'') = checkPlayerPowerUp player' powerups'
        projectiles' = map (tick t) state.projectiles
        enemies' =  map (tick t) state.enemies
        (projectiles'', enemies'', powerups''') = checkHits projectiles' enemies'
        sfxs' = map (SFX.tick dt) state.sfxs
    in {state | 
        player <- player''
       , projectiles <- projectiles''
       , enemies <- enemies''
       , sfxs <- sfxs'
       , powerups <- powerups'' ++ powerups'''
       }

checkPlayerPowerUp : Player -> [PowerUp] -> (Player, [PowerUp])
checkPlayerPowerUp = checkPlayerPowerUp' []

checkPlayerPowerUp' : [PowerUp] -> Player -> [PowerUp] -> (Player, [PowerUp])
checkPlayerPowerUp' ps' p ps =
    if | p.traits.time < 0 -> (p, ps)
       | otherwise -> 
    case ps of
      [] -> (p, reverse ps')
      (powerup::rest) -> 
          if | not <| intersect p powerup -> checkPlayerPowerUp' (powerup::ps') p rest
             | otherwise -> 
                let traits = p.traits
                    p' = { p | 
                           traits <- { traits |
                                       fire <- powerup.traits.powerup } }
                in (p', ps' ++ rest)
      

checkPlayerHit : Player -> [Enemy] -> Player
checkPlayerHit p es =
    case es of
      [] -> p
      (e::es') -> if 
                     | p.traits.destroyed -> p
                     | p.traits.time < 0 -> p
                     | p.traits.lives < 1 -> p
                     | (intersect p e) -> 
                         let traits = p.traits
                         in { p | traits <- { traits |
                                              destroyed <- True
                                            , lives <- traits.lives - 1 } }
                     | otherwise -> checkPlayerHit p es'

checkHits : [Missile] -> [Enemy] -> ([Missile], [Enemy], [PowerUp])
checkHits = checkHits' [] []

checkHits' : [PowerUp] -> [Missile] -> [Missile] -> [Enemy] -> ([Missile], [Enemy], [PowerUp])
checkHits' ps acc_ms ms es =
    case ms of
      [] -> (acc_ms, reverse es, ps)
      (m::ms') ->
          if | m.traits.destroyed -> checkHits' ps (m::acc_ms) ms' es
             | otherwise ->
                 let (hit, es', ps') = checkHitEnemy m es
                 in if
                     -- If hit, mark missile destroyed
                     | hit -> 
                         let mtraits = m.traits
                             m' = { m | traits <- { mtraits | destroyed <- True } }
                         in checkHits' (ps' ++ ps) (m'::acc_ms) ms' es'
                     -- Otherwise keep it
                     | otherwise -> checkHits' (ps' ++ ps) (m::acc_ms) ms' es'

checkHitEnemy : Missile -> [Enemy] -> (Bool, [Enemy], [PowerUp])
checkHitEnemy = checkHitEnemy' []

checkHitEnemy' : [Enemy] -> Missile -> [Enemy] -> (Bool, [Enemy], [PowerUp])
checkHitEnemy' acc m es =
    case es of
      [] -> (False, acc, [])
      (e::es') -> if 
                    -- If the Enemys health is less than 1, skip it
                    | e.traits.health <= 0 -> checkHitEnemy' (e::acc) m es' 
                    -- If the Missile doesn't hit the enemy, continue down the list
                    | not <| intersect m e -> checkHitEnemy' (e::acc) m es'
                    -- If the Missle does hit the enemy, reduce the enemies health by the damage amount of the Missile.
                    | otherwise -> 
                        let traits = e.traits
                            e' = { e | traits <- { traits | health <- traits.health - m.traits.damage } }
                            _ = Debug.watch "Hit" e'
                            ps = if | e'.traits.health < 1 -> Debug.watch "Loot" (traits.loot traits.pos)
                                    | otherwise -> Debug.watch "Loot" []
                        in (True, es' ++ (e' :: acc), ps)
