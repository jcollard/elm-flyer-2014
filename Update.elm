module Update where

import List
import SFX (SFX)
import Object (..)
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State (..)
import Player (Player)
import Enemy.Generator (nextWave)
import Debug

import Player
import Physics

update : RealWorld -> Input -> State -> State
update rw input state = 
    let state' = Debug.watch "State" state in
    case input of
      Passive t ->
          if | state.paused -> state
             | otherwise ->
               let fps = Debug.watch "FPS" (1000 / t)
                   state' = (cleanUp << Physics.physics t) { state | time <- state.time + (t/20) }
                   state'' = checkWave state'
               in state''
      _ ->  if | state.gameover -> state
               | otherwise -> 
                   let state' = handleFire input state
                       player' = Player.move state'.player input
                   in { state' | player <- player' }

checkWave : State -> State
checkWave state =
    if | (not << List.isEmpty) state.enemies -> state
       | otherwise ->
           let (enemies', generator') = nextWave state.generator
           in { state | 
                enemies <- enemies'
              , generator <- generator'
              }


handleFire : Input -> State -> State
handleFire input state = 
           case input of
             Tap k -> if | k `Keys.equals` Keys.space && state.menu -> { initialState | menu <- False }
                         | k `Keys.equals` Keys.space -> 
                              let ps = Player.fire state.player
                              -- This is super annoying...
                              -- It would be much beter if you could 
                              -- do { player.traits | modifiers }
                              -- but the parser can't figure it out
                                  player = state.player
                                  traits = player.traits
                                  cooldown' = if isEmpty ps 
                                                 then traits.cooldown
                                                 else (head ps).traits.cooldown
                                  traits' = { traits | cooldown <- cooldown' }
                                  player' = { player | traits <- traits' }
                              in { state | 
                                   projectiles <- ps ++ state.projectiles
                                 , player <- player' 
                                 }
                         | otherwise -> state
             _ -> state


cleanUp : State -> State
cleanUp state =
    let (pps, newSFX) = cleanObjects state.projectiles
        (objs, newSFX') = cleanObjects state.enemies
        (player', newSFX''') = cleanPlayer state.player
        sfxs' = filter cleanSFX (newSFX''' ++ newSFX ++ newSFX' ++ state.sfxs)
        gameover' = player'.traits.lives < 1
    in { state | 
         projectiles <- pps
       , enemies <- objs
       , sfxs <- sfxs'
       , player <- player'
       , gameover <- gameover'
       }

cleanPlayer : Player -> (Player, [SFX])
cleanPlayer p =
    if | p.traits.destroyed -> 
           let traits = p.traits
               p' = { p | traits <- { traits |
                                      destroyed <- False
                                    , time <- -200
                                    }
                    }
           in ( p' , [p.destroyedSFX p.traits] )
       | otherwise -> (p, [])

cleanSFX : SFX -> Bool
cleanSFX { time, duration } = time < duration

cleanObjects : [Object a b] -> ([Object a b], [SFX])
cleanObjects = cleanObjects' ([], [])

cleanObjects' : ([Object a b], [SFX]) -> [Object a b] -> ([Object a b], [SFX])
cleanObjects' (acc_os, sfxs) os =
    case os of
      [] -> (acc_os, sfxs)
      (o::os') -> if | o.traits.destroyed -> 
                         let sfx = o.destroyedSFX o.traits
                         in cleanObjects' (acc_os, sfx::sfxs) os'
                     | otherwise -> cleanObjects' (o::acc_os, sfxs) os'
         