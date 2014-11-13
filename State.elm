module State where

import Util (..)
import SFX (..)
import Object (..)
import Enemy (..)
import Missile (..)
import Player (..)
import PowerUp (..)
import Enemy.Generator (Generator, theGenerator)
import Enemy.AlienWarrior as AlienWarrior

type State = { player : Player
             , projectiles : [Missile]
             , enemies : [Enemy]
             , time : Time
             , sfxs : [SFX]
             , powerups : [PowerUp]
             , generator : Generator 
             , gameover : Bool
             , menu : Bool
             , paused : Bool
             }

initialState : State
initialState = { player = player 
               , projectiles = []
               , enemies = []
               , sfxs = []
               , powerups = []
               , time = 0
               , generator = theGenerator 42
               , gameover = False
               , menu = True
               , paused = False
               }

