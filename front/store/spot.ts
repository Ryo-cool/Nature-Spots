import { Module } from "vuex"
import { RootState, SpotState, Spot } from "./types"

const state = (): SpotState => ({
  spots: [],
  currentSpot: null,
  loading: false,
  error: null,
})

const getters = {
  allSpots: (state: SpotState): Spot[] => state.spots,
  currentSpot: (state: SpotState): Spot | null => state.currentSpot,
  isLoading: (state: SpotState): boolean => state.loading,
  error: (state: SpotState): string | null => state.error,
}

const mutations = {
  SET_SPOTS(state: SpotState, spots: Spot[]) {
    state.spots = spots
  },
  SET_CURRENT_SPOT(state: SpotState, spot: Spot | null) {
    state.currentSpot = spot
  },
  SET_LOADING(state: SpotState, loading: boolean) {
    state.loading = loading
  },
  SET_ERROR(state: SpotState, error: string | null) {
    state.error = error
  },
}

const actions = {
  async fetchSpots({ commit }) {
    commit("SET_LOADING", true)
    try {
      const response = await this.$axios.get("/spots")
      commit("SET_SPOTS", response.data)
      commit("SET_ERROR", null)
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    } finally {
      commit("SET_LOADING", false)
    }
  },

  async fetchSpot({ commit }, id: number) {
    commit("SET_LOADING", true)
    try {
      const response = await this.$axios.get(`/spots/${id}`)
      commit("SET_CURRENT_SPOT", response.data)
      commit("SET_ERROR", null)
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    } finally {
      commit("SET_LOADING", false)
    }
  },

  async createSpot({ commit }, spot: Partial<Spot>) {
    commit("SET_LOADING", true)
    try {
      const response = await this.$axios.post("/spots", spot)
      const newSpot = response.data
      commit("SET_SPOTS", [...state().spots, newSpot])
      commit("SET_ERROR", null)
      return newSpot
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    } finally {
      commit("SET_LOADING", false)
    }
  },

  async updateSpot(
    { commit },
    { id, spot }: { id: number; spot: Partial<Spot> }
  ) {
    commit("SET_LOADING", true)
    try {
      const response = await this.$axios.put(`/spots/${id}`, spot)
      const updatedSpot = response.data
      const spots = state().spots.map((s) => (s.id === id ? updatedSpot : s))
      commit("SET_SPOTS", spots)
      commit("SET_CURRENT_SPOT", updatedSpot)
      commit("SET_ERROR", null)
      return updatedSpot
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    } finally {
      commit("SET_LOADING", false)
    }
  },

  async deleteSpot({ commit }, id: number) {
    commit("SET_LOADING", true)
    try {
      await this.$axios.delete(`/spots/${id}`)
      const spots = state().spots.filter((s) => s.id !== id)
      commit("SET_SPOTS", spots)
      commit("SET_CURRENT_SPOT", null)
      commit("SET_ERROR", null)
    } catch (error) {
      commit("SET_ERROR", error.message)
      throw error
    } finally {
      commit("SET_LOADING", false)
    }
  },
}

const spotModule: Module<SpotState, RootState> = {
  state,
  getters,
  mutations,
  actions,
}

export default spotModule
