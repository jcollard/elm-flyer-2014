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
        (enemies, g'') = createEnemies g.wave num_enemies g'
    in (enemies, {g | generator <- g'', wave <- g.wave + 1})

createEnemies : Int -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies = createEnemies' []

createEnemies' : [Enemy] -> Int -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies' es wave num_enemies g = 
    if | (num_enemies <= 0) -> (es, g)
       | otherwise -> 
           let (p, g') = float g
           in if | p <= 1 -> 
                     let (e, g') = single wave g
                     in createEnemies' (e::es) wave (num_enemies - 1) g'
                 | otherwise ->
                     let (new, g') = train wave num_enemies g
                         num_enemies' = num_enemies - (length new)
                     in createEnemies' (new ++ es) wave num_enemies' g'

-- Groups

single : Int -> RndGen -> (Enemy, RndGen)
single wave g = 
    let 
        (x_off, g') = floatRange (100, 1000) g
        (y_off, g'') = floatRange (-100, 100) g'
        pos = { x = screenBounds.right + x_off, y = 0 + y_off }
        (passive, g''') = movement wave g''
        ctor = AlienWarrior.spawn
        enemy = ctor pos
        enemy' = { enemy | passive <- passive pos }
    in (enemy', g''')

train : Int -> Int -> RndGen -> ([Enemy], RndGen)
train wave n g = ([], g)
                         
         
-- Movements

type PassiveFunction = Location -> Time -> EnemyTraits -> EnemyTraits

movement : Int -> RndGen -> (PassiveFunction, RndGen)
movement wave g =
    let (p, g') = float g
    in if | p <= 1 -> 
              let (speed, g'') = floatRange (3, 10) g'
              in (straight speed, g'')
          | otherwise -> (straight 5, g')

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