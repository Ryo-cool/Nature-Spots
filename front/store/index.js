// ログインフラグ
export const state = () => ({
  current: {
    user: null,
  },

  styles: {
    beforeLogin: {
      appBarHeight: 56
    }
  },

  rememberRoute: {
    name: 'index',
    params: {}
  }
})

export const getters = {}

export const mutations = {

  setCurrentUser (state, payload) {
    state.current.user = payload
  },
  setRememberRoute (state, payload) {
    state.rememberRoute = payload
  }

}

export const actions = {
  // 現在のユーザーを設定する
  getCurrentUser ({ commit }, user) {
    commit('setCurrentUser', user)
  },
  // ログイン前にアクセスしたルートを記憶する
  getRememberRoute ({ commit }, route) {
    route = route || { name: 'index', params: {} }
    commit('setRememberRoute', { name: route.name, params: route.params })
  }
}