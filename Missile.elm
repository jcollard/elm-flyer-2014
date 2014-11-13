module Missile where

import SFX (SFX)
import Util (..)
import Object (..)

type AdditionalTraits = { damage : Int,
                          time : Time,
                          cooldown : Time }

type MissileTraits = Traits AdditionalTraits

type Missile = Object AdditionalTraits {}

img : Form
img = toForm (image 25 25 "../assets/standard-missile.gif")

missile : MissileTraits -> Missile
missile traits = 
    let m = object traits
    in { m | destroyedSFX <- destroyedSFX }

destroyedSFX : Traits a -> SFX
destroyedSFX { pos } =
    { pos = pos
    , time = 0
    , duration = 50
    , sfx = (\t -> circle (t/2) |> filled orange)
    }

defaultTraits : MissileTraits
defaultTraits = { pos = { x = 0, y = 0 }
                , dim = { width = 0, height = 0 }
                , form = img
                , time = 0
                , damage = 5
                , cooldown = 15
                , destroyed = False }

passiveBuilder : (Time -> MissileTraits -> MissileTraits) -> Time -> MissileTraits -> MissileTraits
passiveBuilder f dt traits = 
    let traits' = f dt traits
    in checkDestroyed traits'


checkDestroyed : MissileTraits -> MissileTraits
checkDestroyed traits =
    if | outOfBounds traits -> { traits | destroyed <- True }
       | otherwise -> traits          


outOfBounds : MissileTraits -> Bool
outOfBounds traits  =
    let objLeft = traits.pos.x - (traits.dim.width / 2)
        objRight = traits.pos.x + (traits.dim.width / 2)
        objTop = traits.pos.y + (traits.dim.height / 2)
        objBot = traits.pos.y - (traits.dim.height / 2)
    in (objRight < screenBounds.left - 100) 
       || (objLeft > screenBounds.right + 100) 
       || (objBot > screenBounds.top + 500) 
       || (objTop < screenBounds.bottom - 500)                  