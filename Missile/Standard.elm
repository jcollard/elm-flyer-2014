module Missile.Standard where

import Object (..)
import Missile (..)

img = toForm (image 25 25 "assets/standard-missile.gif")

spawn : Location -> [Missile]
spawn pos = [{pos = pos,
              dim = {width = 25, height = 25},
              vel = {x = 5, y = 0},
              form = img,
              damage = 5}]
