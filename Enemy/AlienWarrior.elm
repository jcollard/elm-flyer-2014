module Enemy.AlienWarrior where

import Object (..)
import Enemy (..)

width = 50
height = 50

img : Form
img = toForm (image width height "../assets/alien-warrior.gif")



spawn : Location -> Enemy
spawn pos = 
  { 
    pos = pos,
    vel = { x = 0, y = 0 },
    dim = { width = width, height = height },
    form = img,
    health = 10,
    time = 0,
    action = action
  }

action : Time -> Velocity
action t = {x = -3 + 3.5 * ( sin << degrees <| t), y = 8 * (cos << degrees <| 5*t)}