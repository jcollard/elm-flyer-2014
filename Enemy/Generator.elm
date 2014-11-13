module Enemy.Generator where

import Util (..)
import Enemy.AlienWarrior as AlienWarrior
import Enemy (Enemy, enemy)
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
    let (num_enemies, g') = int32Range (g.wave, g.wave*g.wave) g.generator
        (enemies, g'') = createEnemies g.wave num_enemies g'
    in (enemies, {g | generator <- g'', wave <- g.wave + 1})

createEnemies : Int -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies = createEnemies' []

createEnemies' : [Enemy] -> Int -> Int -> RndGen -> ([Enemy], RndGen)
createEnemies' es wave num_enemies g = 
    if | (num_enemies <= 0) -> (es, g)
       | otherwise -> 
           let (p, g') = float g
           in if | p < 0.90 -> 
                     let (e, g') = single wave g
                     in createEnemies' (e::es) wave (num_enemies - 1) g'
                 | otherwise ->
                     let (new, g') = train wave num_enemies g
                         num_enemies' = num_enemies - (length new)
                     in createEnemies' (new ++ es) wave num_enemies' g'

single : Int -> RndGen -> (Enemy, RndGen)
single wave g = 
    let pos = { x = screenBounds.right + 100, y = screenBounds.height/2 }
        ctor = AlienWarrior.spawn
        enemy = ctor pos
    in (enemy, g)

train : Int -> Int -> RndGen -> ([Enemy], RndGen)
train wave n g = ([], g)
                         
              