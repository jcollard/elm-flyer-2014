module Update where
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State

type State = State.State
pos = State.Position

update : RealWorld -> Input -> State -> State
update rw input state =
   let player = state.player
       player' = movePlayer player input
   in {state | player <- player'}

-- There's no player class yet
movePlayer : State.Object a -> Input -> State.Object a
movePlayer player input = case input of
    Key k -> if | k `Keys.equals` Keys.d ->
                    {player | pos <- pos (player.pos.x + 2) (player.pos.y)}
                | k `Keys.equals` Keys.a ->
                    {player | pos <- pos (player.pos.x - 2) (player.pos.y)}
                | k `Keys.equals` Keys.w ->
                    {player | pos <- pos (player.pos.x) (player.pos.y + 2)}
                | k `Keys.equals` Keys.s ->
                    {player | pos <- pos (player.pos.x) (player.pos.y - 2)}
                | otherwise -> player
