module State where

import Util (..)
import SFX (..)
import Object (..)
import Enemy (..)
import Missile (..)
import Player (..)
import Enemy.AlienWarrior as AlienWarrior

type State = { player : Player
             , projectiles : [Missile]
             , enemies : [Enemy]
             , time : Time
             , sfxs : [SFX] }

initialState : State
initialState = { player = player 
               , projectiles = []
               , enemies = [ AlienWarrior.spawn {x = 550, y = 0} 
                           ]
               , sfxs = []
               , time = 0 }

