import { Module } from "vuex"
import { RootState, AuthState, User } from "./types"

const state = (): AuthState => ({
  user: null,
  token: null,
  isAuthenticated: false,
})

const getters = {
  isAuthenticated: (state: AuthState): boolean => state.isAuthenticated,
  user: (state: AuthState): User | null => state.user,
}

const mutations = {
  SET_USER(state: AuthState, user: User | null) {
    state.user = user
  },
  SET_TOKEN(state: AuthState, token: string | null) {
    state.token = token
  },
  SET_AUTH(state: AuthState, isAuth: boolean) {
    state.isAuthenticated = isAuth
  },
}

const actions = {
  async login({ commit }, credentials: { email: string; password: string }) {
    try {
      // APIリクエストの実装
      const response = await this.$axios.post("/auth/login", credentials)
      const { user, token } = response.data

      commit("SET_USER", user)
      commit("SET_TOKEN", token)
      commit("SET_AUTH", true)

      // トークンをlocalStorageに保存
      localStorage.setItem("token", token)
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    }
  },

  async logout({ commit }) {
    try {
      await this.$axios.post("/auth/logout")
      commit("SET_USER", null)
      commit("SET_TOKEN", null)
      commit("SET_AUTH", false)
      localStorage.removeItem("token")
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    }
  },

  async fetchUser({ commit }) {
    try {
      const response = await this.$axios.get("/auth/user")
      const user = response.data
      commit("SET_USER", user)
      commit("SET_AUTH", true)
    } catch (error) {
      commit("SET_USER", null)
      commit("SET_AUTH", false)
      commit("SET_ERROR", error.message)
      throw error
    }
  },
}

const authModule: Module<AuthState, RootState> = {
  state,
  getters,
  mutations,
  actions,
}

export default authModule
