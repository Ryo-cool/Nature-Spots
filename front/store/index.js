// ログインフラグ
export const state = () => ({
  loggedIn: true,
  styles: {
    beforeLogin: {
      appBarHeight: 56
    }
  }
})

export const getters = {}

export const mutations = {
  setLoggedIn (state, payload) {
    state.loggedIn = payload
  }
}

export const actions = {
  login ({ commit }) {
    commit('setLoggedIn', true)
  },
  logout ({ commit }) {
    commit('setLoggedIn', false)
  }

}