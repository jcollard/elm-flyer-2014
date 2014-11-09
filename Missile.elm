module Missile where

import Object (..)

type AdditionalTraits = { damage : Int,
                           time : Time,
                           cooldown : Time }

type MissileTraits = Traits AdditionalTraits

type Missile = Object AdditionalTraits

