module Enemy.Generator where

import Util (..)
import Enemy.AlienWarrior as AlienWarrior
import Enemy (Enemy, EnemyTraits, enemy, checkDestroyed)
import Generator.Standard (..)
import Generator
import Generator (int32Range, floatRange, float)

type RndGen = Generator.Generator Standard

type Generator = { generator : RndGen,
                   wave : Int }

theGenerator : Int -> Generator
theGenerator n = { generator = generator n,
                   wave = 1 }

nextWave : Generator -> ([Enemy], Generator)
nextWave g = 
    let (num_enemies, g') = int32Range (g.wave, 5*g.wave) g.generator
        (enemies, g'') = createEnemies (toFloat g.wave) num_enemies g'
    in (enemies, {g | generator <- g'', wave <- g.wave + 1})

createEnemies : Float -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies = createEnemies' []

createEnemies' : [Enemy] -> Float -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies' es wave num_enemies g = 
    if | (num_enemies <= 0) -> (es, g)
       | otherwise -> 
           let (p, g') = float g
           in if | p <= 1 - (max (wave-1) 0) * 0.05 -> 
                     let (e, g') = single wave g
                     in createEnemies' (e::es) wave (num_enemies - 1) g'
                 | otherwise ->
                     let (new, g') = train wave num_enemies g
                         num_enemies' = num_enemies - (length new)
                     in createEnemies' (new ++ es) wave num_enemies' g'

-- Groups

single : Float -> RndGen -> (Enemy, RndGen)
single wave g = 
    let 
        (x_off, g') = floatRange (100, 200*wave) g
        (y_off, g'') = floatRange (-200, 200) g'
        pos = { x = screenBounds.right + x_off, y = 0 + y_off }
        (passive, g''') = movement wave g''
        ctor = AlienWarrior.spawn
        enemy = ctor pos
        enemy' = { enemy | passive <- passive pos }
    in (enemy', g''')

train : Float -> Int -> RndGen -> ([Enemy], RndGen)
train wave n g = 
    let (size, g') = int32Range (5, (min 25 n)) g
        (x_off, g'') = floatRange (100, 200*wave) g'
        (y_off, g''') = floatRange (-200, 200) g''
        (space, g'''') = floatRange (10, 20) g'''
        pos = { x = screenBounds.right + x_off, y = 0 + y_off }
        (passive, g''''') = movement wave g''''
        ctor = AlienWarrior.spawn
        enemy = ctor pos
        enemy' = { enemy | passive <- passive pos }
        traits' = enemy'.traits
        create n = { enemy' | traits <- { traits' | time <- space * toFloat -n } }
        enemies = map create [0..size]
    in (enemies, g''''')

                         
         
-- Movements

type PassiveFunction = Location -> Time -> EnemyTraits -> EnemyTraits

movement : Float -> RndGen -> (PassiveFunction, RndGen)
movement wave g =
    let (p, g') = float g
    in if | p <= 1.0 - ((wave - 1) * 0.05) -> 
              let (speed, g'') = floatRange (3, 10) g'
              in (straight speed, g'')
          | p <= 1.0 - (max (wave - 5) 0) * 0.05 -> basicSine g'
          | otherwise -> oscillate g'

straight : Float -> Location -> Time -> EnemyTraits -> EnemyTraits
straight speed {x, y} dt traits =
         let t = traits.time
             t' = t + dt
             x' = x - speed*t
             y' = y
             pos' = { x = x', y = y' }
         in checkDestroyed { traits |
                             time <- t'
                           , pos <- pos'
                           }

basicSine : RndGen -> (PassiveFunction, RndGen)
basicSine g =
    let (leftPull, g') = floatRange (3, 10) g
        (amp, g'') = floatRange (30, 200) g'
        (per, g''') = floatRange (1, 3) g''
        passive { x , y } dt traits =
            let t = traits.time
                t' = t + dt
                x' = x - leftPull*t
                y' = y + amp * sin( degrees <| per * t)
                pos' = { x = x', y = y' }
            in checkDestroyed { traits | 
                                time <- t'
                              , pos <- pos'
                              }
    in (passive, g''')

oscillate : RndGen -> (PassiveFunction, RndGen)
oscillate g =
    let (leftPull, g') = floatRange (3, 10) g
        (rightPull, g'') = floatRange (0, 10*leftPull) g'
        (pullP, g''') = floatRange (1, 2) g''
        (amp, g'''') = floatRange (30, 200) g'''
        (per, g''''') = floatRange (1, 3) g''''
        passive { x, y } dt traits =
            let t = traits.time
                t' = t + dt
                x' = x - leftPull*t + rightPull*sin( degrees <| pullP * t)
                y' = y + amp * cos(degrees <| per * t)
                pos' = { x = x', y = y' }
            in checkDestroyed { traits | time <- t', pos <- pos' }
    in (passive, g''''')