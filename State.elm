module State where

import Util (..)
import SFX (..)
import Object (..)
import Enemy (..)
import Missile (..)
import Player (..)
import Enemy.Generator (Generator, theGenerator)
import Enemy.AlienWarrior as AlienWarrior

type State = { player : Player
             , projectiles : [Missile]
             , enemies : [Enemy]
             , time : Time
             , sfxs : [SFX]
             , generator : Generator 
             , gameover : Bool
             }

initialState : State
initialState = { player = player 
               , projectiles = []
               , enemies = []
               , sfxs = []
               , time = 0
               , generator = theGenerator 42
               , gameover = False
               }

