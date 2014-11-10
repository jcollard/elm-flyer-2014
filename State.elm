module State where

import State.ScreenBounds (..) 
import State.ScreenBounds
import Object (..)
import Enemy (..)
import Missile (..)
import Player (..)
import Enemy.AlienWarrior as AlienWarrior

type State = { player : Player,
               projectiles : [Missile],
               enemies : [Enemy],
               time : Time }

initialState : State
initialState = { player = player, 
                 projectiles = [],
                 enemies = [AlienWarrior.spawn {x = 450, y = 0}],
                 time = 0 }

screenBounds = State.ScreenBounds.screenBounds


