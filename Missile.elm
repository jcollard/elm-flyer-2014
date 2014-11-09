module Missile where

import Object (..)

type Missile = Object { damage: Int }

handleAction : Missile -> Missile
handleAction m = m
