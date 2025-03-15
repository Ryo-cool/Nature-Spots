import { defineStore } from "pinia";
import type { Spot } from "~/types";

export const useSpotStore = defineStore("spot", {
  state: () => ({
    spots: [] as Spot[],
    currentSpot: null as Spot | null,
    loading: false,
    error: null as string | null,
  }),

  getters: {
    allSpots: (state) => state.spots,
    getSpotById: (state) => (id: number) =>
      state.spots.find((spot) => spot.id === id),
    getCurrentSpot: (state) => state.currentSpot,
    isLoading: (state) => state.loading,
    getError: (state) => state.error,
  },

  actions: {
    setSpots(spots: Spot[]) {
      this.spots = spots;
    },

    setCurrentSpot(spot: Spot | null) {
      this.currentSpot = spot;
    },

    setLoading(loading: boolean) {
      this.loading = loading;
    },

    setError(error: string | null) {
      this.error = error;
    },

    async fetchSpots() {
      this.setLoading(true);
      try {
        const config = useRuntimeConfig();
        const response = await $fetch("/api/v1/spots", {
          method: "GET",
          baseURL: config.public.apiBaseUrl,
        });

        this.setSpots(response);
        this.setError(null);
      } catch (error: any) {
        this.setError(error.message || "Failed to fetch spots");
      } finally {
        this.setLoading(false);
      }
    },

    async fetchSpot(id: number) {
      this.setLoading(true);
      try {
        const config = useRuntimeConfig();
        const response = await $fetch(`/api/v1/spots/${id}`, {
          method: "GET",
          baseURL: config.public.apiBaseUrl,
        });

        this.setCurrentSpot(response);
        this.setError(null);
      } catch (error: any) {
        this.setError(error.message || `Failed to fetch spot with id ${id}`);
      } finally {
        this.setLoading(false);
      }
    },

    async createSpot(spot: Partial<Spot>) {
      this.setLoading(true);
      try {
        const config = useRuntimeConfig();
        const authStore = useAuthStore();

        const response = await $fetch("/api/v1/spots", {
          method: "POST",
          body: spot,
          baseURL: config.public.apiBaseUrl,
          headers: {
            Authorization: `Bearer ${authStore.token}`,
          },
        });

        // Add the new spot to the spots array
        this.spots.push(response);
        this.setError(null);
        return response;
      } catch (error: any) {
        this.setError(error.message || "Failed to create spot");
        throw error;
      } finally {
        this.setLoading(false);
      }
    },

    async updateSpot({ id, spot }: { id: number; spot: Partial<Spot> }) {
      this.setLoading(true);
      try {
        const config = useRuntimeConfig();
        const authStore = useAuthStore();

        const response = await $fetch(`/api/v1/spots/${id}`, {
          method: "PUT",
          body: spot,
          baseURL: config.public.apiBaseUrl,
          headers: {
            Authorization: `Bearer ${authStore.token}`,
          },
        });

        // Update the spot in the spots array
        const index = this.spots.findIndex((s) => s.id === id);
        if (index !== -1) {
          this.spots[index] = response;
        }

        if (this.currentSpot?.id === id) {
          this.setCurrentSpot(response);
        }

        this.setError(null);
        return response;
      } catch (error: any) {
        this.setError(error.message || `Failed to update spot with id ${id}`);
        throw error;
      } finally {
        this.setLoading(false);
      }
    },

    async deleteSpot(id: number) {
      this.setLoading(true);
      try {
        const config = useRuntimeConfig();
        const authStore = useAuthStore();

        await $fetch(`/api/v1/spots/${id}`, {
          method: "DELETE",
          baseURL: config.public.apiBaseUrl,
          headers: {
            Authorization: `Bearer ${authStore.token}`,
          },
        });

        // Remove the spot from the spots array
        this.spots = this.spots.filter((spot) => spot.id !== id);

        if (this.currentSpot?.id === id) {
          this.setCurrentSpot(null);
        }

        this.setError(null);
      } catch (error: any) {
        this.setError(error.message || `Failed to delete spot with id ${id}`);
        throw error;
      } finally {
        this.setLoading(false);
      }
    },
  },
});
