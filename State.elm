module State where

type State = { player : Object {},
               playerProjectiles : [Missile],
               objects : [Object {}] }

type Position = { x : Float, y : Float }
type Velocity = { x : Float, y : Float }
type BoundingBox = { x : Float, y : Float, width : Float, height : Float }

type Object a = { a | pos : Position, vel: Velocity,
                      box : BoundingBox, form : Form }

initialState : State
initialState = { player = player, playerProjectiles = [],
                 objects = [initialObject] }

initialObject = { pos = { x = 0, y = 0 },
                  vel = { x = -3, y = 0},
                  box = { x = -75, y = 70.5, width = 150, height = 141 },
                  form = toForm (image 150 141 "assets/alien-warrior.gif")}

type Player = Object {}
player = { pos = {x = -400, y = 0},
           vel = {x = 0, y = 0},
           box = { x = -20, y = 25, width = 100, height = 57 },
           form = toForm (image 100 57 "assets/space-ship.gif")}
magicMissile = player.box.width / 2

type Missile = Object {damage: Int }

stdMissileImg = toForm (image 25 25 "assets/standard-missile.gif")

standardMissile : Position -> Missile
standardMissile pos = {pos = {x = pos.x + magicMissile, y = pos.y},
                       box = {x = -12.5, y = 12.5, width = 25, height = 25},
                       vel = {x = 5, y = 0},
                       form = stdMissileImg,
                       damage = 5}

screenBounds = {left = -500, right = 500, top = 250, bottom = -250,
                width = 1000, height = 500}
