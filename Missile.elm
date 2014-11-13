module Missile where

import Object (..)

type AdditionalTraits = { damage : Int,
                          time : Time,
                          cooldown : Time }

type MissileTraits = Traits AdditionalTraits

type Missile = Object AdditionalTraits {}

img : Form
img = toForm (image 25 25 "../assets/standard-missile.gif")

defaultTraits : MissileTraits
defaultTraits = { pos = { x = 0, y = 0 }
                , dim = { width = 0, height = 0 }
                , form = img
                , time = 0
                , damage = 5
                , cooldown = 15
                , destroyed = False }
                  