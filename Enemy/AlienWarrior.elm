module Enemy.AlienWarrior where

import Object (..)
import Enemy (..)

width = 50
height = 50

img : Form
img = toForm (image width height "../assets/alien-warrior.gif")

spawn : Location -> Enemy
spawn pos = 
    let traits = { pos = pos,
                   health = 10,
                   dim = { width = width, height = height },
                   form = img }
        warrior = enemy traits
    in { warrior | passive <- passive }

passive : Time -> EnemyTraits -> EnemyTraits
passive dt traits = 
    let t = traits.time
        t' = t + dt
        vel' = {x = -5 + 5 * ( sin << degrees <| 3*t), y = 12 * (cos << degrees <| 5*t)}
    in { traits | time <- t', vel <- vel' }