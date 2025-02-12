import { Store } from "vuex"
import { RootState } from "./types"
import auth from "./auth"
import spot from "./spot"

const createStore = (): Store<RootState> => {
  return new Store({
    state: {
      version: "1.0.0",
    },
    modules: {
      auth,
      spot,
    },
  })
}

export default createStore
