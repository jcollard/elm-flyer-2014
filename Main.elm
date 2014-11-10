import Playground
import Render (render)
import State (initialState)
import Update (update)


main = Playground.play { render = render, initialState = initialState, update = update }