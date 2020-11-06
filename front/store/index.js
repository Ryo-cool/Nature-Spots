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
  },

  toast: {
    msg: null,
    color: 'error',
    timeout: 4000
  }
})

export const getters = {}

export const mutations = {

  setCurrentUser (state, payload) {
    state.current.user = payload
  },
  setRememberRoute (state, payload) {
    state.rememberRoute = payload
  },
  setToast (state, payload) {
    state.toast = payload
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
  },
  // トーストデータをセットする
  getToast ({ commit }, toast) {
    toast.color = toast.color || 'error'
    toast.timeout = toast.timeout || 4000
    commit('setToast', toast)
  }
}