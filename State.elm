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
                  box = { x = -10, y = -10, width = 20, height = 20 },
                  form = circle 50 |> filled blue }

type Player = Object {}
player = { pos = {x = -400, y = 0},
           vel = {x = 0, y = 0},
           box = { x = -20, y = -25, width = 100, height = 57 },
           form = toForm (image 100 57 "assets/space-ship.gif")}
magicMissile = player.box.width / 2

type Missile = Object {damage: Int }

stdMissileImg = toForm (image 25 25 "assets/standard-missile.gif")

standardMissile : Position -> Missile
standardMissile pos = {pos = {x = pos.x + magicMissile, y = pos.y},
                       box = {x = -5, y = -2, width = 10, height = 4},
                       vel = {x = 5, y = 0},
                       form = stdMissileImg,
                       damage = 5}

screenBounds : {left: Float, right: Float, top: Float, bottom: Float}
screenBounds = {left = -500, right = 500, top = 250, bottom = -250}
