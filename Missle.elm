module Missle where

import Object (..)

type Missle = Object {damage: Int }

img = toForm (image 25 25 "assets/standard-missile.gif")


standardMissle : Location -> [Missle]
standardMissle pos = [{pos = pos,
                       dim = {width = 25, height = 25},
                       vel = {x = 5, y = 0},
                       form = img,
                       damage = 5}]
