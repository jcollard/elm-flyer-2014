module PowerUp where

import Object (..)
import Util (..)
import Missile (Missile)

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
    in { p | passive <- passive }

passive : Time -> PowerUpTraits -> PowerUpTraits
passive t traits =
    let destroyed' = traits.pos.x < -(screenBounds.width/2 + 50)
    in  { traits |
          pos <- { x = traits.pos.x - 3*t, y = traits.pos.y } 
        , destroyed <- destroyed'
        }