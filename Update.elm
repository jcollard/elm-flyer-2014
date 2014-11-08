module Update where
import Playground (..)
import Playground.Input (..)
import Keyboard.Keys as Keys
import State
import Physics

type State = State.State
pos = State.Position

update : RealWorld -> Input -> State -> State
update rw input state = case input of
    Passive t -> Physics.physics t state
    otherwise ->
        let player = state.player
            player' = movePlayer player input
            playerProjectiles' = addNewProjectiles player'
                state.playerProjectiles input
        in {state | player <- player', playerProjectiles <- playerProjectiles' }

-- There's no player class yet
movePlayer : State.Player -> Input -> State.Player
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
    otherwise -> player


addNewProjectiles : State.Player -> [State.Missile] -> Input -> [State.Missile]
addNewProjectiles player ms input = case input of
    Tap k -> if | k `Keys.equals` Keys.space ->
            State.standardMissile player.pos :: ms
                | otherwise -> ms
    otherwise -> ms
