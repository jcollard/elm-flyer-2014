module Enemy.AlienWarrior where

import Util (..)
import Object (..)
import Enemy (..)

width = 50
height = 50

img : Form
img = toForm (image width height "../assets/alien-warrior.gif")

spawn : Location -> Enemy
spawn pos = 
    let traits = { pos = pos,
                   health = 1,
                   dim = { width = width, height = height },
                   form = img }
        warrior = enemy traits
    in { warrior | passive <- passive pos }

passive : Location -> Time -> EnemyTraits -> EnemyTraits
passive { x, y } dt traits = 
    let t = traits.time
        t' = t + dt
        x' = x - 3*t + 200*sin( degrees <| 1.5*t)
        y' = y + 150 * (cos << degrees <| 2*t)
        pos' = { x = x', y = y' }
    in checkDestroyed { traits | time <- t', pos <- pos' }