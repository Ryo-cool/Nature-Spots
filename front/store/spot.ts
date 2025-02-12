import { Module, ActionContext } from "vuex";
import { RootState, SpotState } from "./types";
import { NuxtAxiosInstance } from '@nuxtjs/axios';

interface SpotActionContext extends ActionContext<SpotState, RootState> {
  $axios?: NuxtAxiosInstance;
}

interface SpotData {
  id: number;
  name: string;
  description: string;
  location: string;
  images: string[];
}

const state = (): SpotState => ({
  spots: [],
  currentSpot: null,
  loading: false,
  error: null,
});

const getters = {
  allSpots: (state: SpotState): SpotData[] => state.spots,
  currentSpot: (state: SpotState): SpotData | null => state.currentSpot,
  isLoading: (state: SpotState): boolean => state.loading,
  error: (state: SpotState): string | null => state.error,
};

const mutations = {
  SET_SPOTS(state: SpotState, spots: SpotData[]) {
    state.spots = spots;
  },
  SET_CURRENT_SPOT(state: SpotState, spot: SpotData | null) {
    state.currentSpot = spot;
  },
  SET_LOADING(state: SpotState, loading: boolean) {
    state.loading = loading;
  },
  SET_ERROR(state: SpotState, error: string | null) {
    state.error = error;
  },
};

const actions = {
  async fetchSpots({ commit, $axios }: SpotActionContext) {
    if (!$axios) throw new Error('$axios is not available');
    commit("SET_LOADING", true);
    try {
      const { data } = await $axios.get("/spots");
      commit("SET_SPOTS", data);
      commit("SET_ERROR", null);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : '不明なエラーが発生しました';
      commit("SET_ERROR", errorMessage);
    } finally {
      commit("SET_LOADING", false);
    }
  },

  async fetchSpot({ commit, $axios }: SpotActionContext, id: number) {
    if (!$axios) throw new Error('$axios is not available');
    commit("SET_LOADING", true);
    try {
      const { data } = await $axios.get(`/spots/${id}`);
      commit("SET_CURRENT_SPOT", data);
      commit("SET_ERROR", null);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : '不明なエラーが発生しました';
      commit("SET_ERROR", errorMessage);
    } finally {
      commit("SET_LOADING", false);
    }
  },

  async createSpot({ commit, $axios }: SpotActionContext, spot: Partial<SpotData>) {
    if (!$axios) throw new Error('$axios is not available');
    commit("SET_LOADING", true);
    try {
      const { data } = await $axios.post("/spots", spot);
      commit("SET_SPOTS", [...state().spots, data]);
      commit("SET_ERROR", null);
      return data;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : '不明なエラーが発生しました';
      commit("SET_ERROR", errorMessage);
      throw error;
    } finally {
      commit("SET_LOADING", false);
    }
  },

  async updateSpot(
    { commit, $axios }: SpotActionContext,
    { id, spot }: { id: number; spot: Partial<SpotData> }
  ) {
    if (!$axios) throw new Error('$axios is not available');
    commit("SET_LOADING", true);
    try {
      const { data } = await $axios.put(`/spots/${id}`, spot);
      const spots = state().spots.map((s) => (s.id === id ? data : s));
      commit("SET_SPOTS", spots);
      commit("SET_CURRENT_SPOT", data);
      commit("SET_ERROR", null);
      return data;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : '不明なエラーが発生しました';
      commit("SET_ERROR", errorMessage);
      throw error;
    } finally {
      commit("SET_LOADING", false);
    }
  },

  async deleteSpot({ commit, $axios }: SpotActionContext, id: number) {
    if (!$axios) throw new Error('$axios is not available');
    commit("SET_LOADING", true);
    try {
      await $axios.delete(`/spots/${id}`);
      const spots = state().spots.filter((s) => s.id !== id);
      commit("SET_SPOTS", spots);
      commit("SET_CURRENT_SPOT", null);
      commit("SET_ERROR", null);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : '不明なエラーが発生しました';
      commit("SET_ERROR", errorMessage);
      throw error;
    } finally {
      commit("SET_LOADING", false);
    }
  },
};

const spotModule: Module<SpotState, RootState> = {
  state,
  getters,
  mutations,
  actions,
};

export default spotModule;
