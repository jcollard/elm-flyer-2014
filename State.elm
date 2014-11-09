module State where

import Object (..)
import Enemy (..)
import Missile (..)
import Player (..)
import Enemy.AlienWarrior as AlienWarrior

type State = { player : Player,
               projectiles : [Missile],
               enemies : [Enemy] }

initialState : State
initialState = { player = player, 
                 projectiles = [],
                 enemies = [AlienWarrior.spawn {x = 450, y = 0},
                            AlienWarrior.spawn {x = 500, y = 150},
                            AlienWarrior.spawn {x = 500, y = -150} ] }



screenBounds = {left = -500, right = 500, top = 250, bottom = -250,
                width = 1000, height = 500}
