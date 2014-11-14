module PowerUp where

import Object (..)
import Util (..)
import Missile (Missile)
import SFX (SFX)
import Debug

type AdditionalTraits = { powerup : Location -> [Missile] }

type PowerUpTraits = Traits AdditionalTraits

type PowerUp = Object AdditionalTraits {}

defaultPowerUp : PowerUpTraits
defaultPowerUp = { destroyed = False
                 , dim = { width = 42, height = 42 }
                 , pos = { x = 0, y = 0 }
                 , form = circle 0 |> filled red
                 , powerup = (\ l -> [] ) }

powerup : PowerUpTraits -> PowerUp
powerup traits = 
    let p = object traits
    in { p | 
         passive <- passive
       , destroyedSFX <- destroyedSFX 
       }

passive : Time -> PowerUpTraits -> PowerUpTraits
passive t traits =
    let destroyed' = traits.pos.x < -(screenBounds.width/2 + 200)
    in  { traits |
          pos <- { x = traits.pos.x - 3*t, y = traits.pos.y } 
        , destroyed <- destroyed'
        }

destroyedSFX : PowerUpTraits -> SFX
destroyedSFX traits = 
    { pos = traits.pos
    , time = 0
    , duration = 200
    , frame = 0
    , sfx = (\t f -> move (0, t) <| scale (1/(max 1 ((toFloat f)/2))) traits.form)
    }