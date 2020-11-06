// ログインフラグ
export const state = () => ({
  current: {
    user: null,
  },

  styles: {
    beforeLogin: {
      appBarHeight: 56
    }
  }
})

export const getters = {}

export const mutations = {

  setCurrentUser (state, payload) {
    state.current.user = payload
  }

}

export const actions = {
  // 現在のユーザーを設定する
  getCurrentUser ({ commit }, user) {
    commit('setCurrentUser', user)
  }
}