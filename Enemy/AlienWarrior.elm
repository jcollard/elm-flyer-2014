module Enemy.AlienWarrior where

import Object (..)
import Enemy (..)

width = 150
height = 141

img : Form
img = toForm (image width height "../assets/alien-warrior.gif")



spawn : Location -> Enemy
spawn pos = 
  { 
    pos = pos,
    vel = { x = 0, y = 0 },
    dim = { width = 15, height = 141 },
    form = img,
    health = 10,
    time = 0,
    action = action
  }

action : Time -> Velocity
action t = {x = -3, y = 8 * (cos << degrees <| 5*t)}