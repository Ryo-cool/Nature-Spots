// Doc: https://www.npmjs.com/package/crypto-js
const cryptoJs = require('crypto-js')
const storage = window.localStorage
const keys = { exp: 'exp' }

class Authentication {
  constructor (ctx) {
    this.store = ctx.store
    this.$axios = ctx.$axios
  }
  // storageに保存
  setStorage (exp) {
    storage.setItem(keys.exp, exp * 1000)
  }
  // storageを削除
  removeStorage () {
    for (const key of Object.values(keys)) {
      storage.removeItem(key)
    }
  }
  // storageの有効期限を複合して返す
  getExpire () {
    return storage.getItem(keys.exp)
  }
  // 有効期限内の場合はtrueを返す
  isAuthenticated () {
    return new Date().getTime() < this.getExpire()
  }
  // ログイン業務
  login ({ exp, user }) {
    this.setStorage(exp)
    this.store.dispatch('getCurrentUser', user)
  }
  // ログアウト業務
  logout () {
    this.$axios.$delete('/api/v1/user_token')
    this.removeStorage()
    this.store.dispatch('getCurrentUser', null)
  }
}

export default ({ store, $axios }, inject) => {
  inject('auth', new Authentication({ store, $axios }))
}