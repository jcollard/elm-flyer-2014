import Playground
import Render (render)
import State (initialState)
import Update (update)


main = Playground.playWithRate 25 { render = render, initialState = initialState, update = update }