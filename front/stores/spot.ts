import { defineStore } from "pinia";
import { ref, computed } from "vue";
import type { Spot } from "~/types";
import { useApi } from "~/composables/useApi";

export const useSpotStore = defineStore("spot", () => {
  const spots = ref<Spot[]>([]);
  const currentSpot = ref<Spot | null>(null);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const allSpots = computed(() => spots.value);
  const getSpotById = computed(
    () => (id: number) => spots.value.find((spot) => spot.id === id),
  );
  const getCurrentSpot = computed(() => currentSpot.value);
  const isLoading = computed(() => loading.value);
  const getError = computed(() => error.value);

  async function withLoading<T>(
    fn: () => Promise<T>,
    errorMessage: string,
  ): Promise<T> {
    loading.value = true;
    error.value = null;
    try {
      return await fn();
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : errorMessage;
      error.value = message;
      throw e;
    } finally {
      loading.value = false;
    }
  }

  async function fetchSpots() {
    await withLoading(async () => {
      const api = useApi();
      const { data } = await api.get<Spot[]>("/api/v1/spots");
      spots.value = data;
    }, "Failed to fetch spots");
  }

  async function fetchSpot(id: number) {
    await withLoading(async () => {
      const api = useApi();
      const { data } = await api.get<Spot>(`/api/v1/spots/${id}`);
      currentSpot.value = data;
    }, `Failed to fetch spot with id ${id}`);
  }

  async function createSpot(spot: Partial<Spot>) {
    return await withLoading(async () => {
      const api = useApi();
      const { data } = await api.post<Spot>("/api/v1/spots", spot);
      spots.value.push(data);
      return data;
    }, "Failed to create spot");
  }

  async function updateSpot({ id, spot }: { id: number; spot: Partial<Spot> }) {
    return await withLoading(async () => {
      const api = useApi();
      const { data } = await api.put<Spot>(`/api/v1/spots/${id}`, spot);

      const index = spots.value.findIndex((s) => s.id === id);
      if (index !== -1) {
        spots.value[index] = data;
      }

      if (currentSpot.value?.id === id) {
        currentSpot.value = data;
      }

      return data;
    }, `Failed to update spot with id ${id}`);
  }

  async function deleteSpot(id: number) {
    await withLoading(async () => {
      const api = useApi();
      await api.delete(`/api/v1/spots/${id}`);

      spots.value = spots.value.filter((spot) => spot.id !== id);

      if (currentSpot.value?.id === id) {
        currentSpot.value = null;
      }
    }, `Failed to delete spot with id ${id}`);
  }

  function setSpots(newSpots: Spot[]) {
    spots.value = newSpots;
  }

  function setCurrentSpot(spot: Spot | null) {
    currentSpot.value = spot;
  }

  return {
    spots,
    currentSpot,
    loading,
    error,
    allSpots,
    getSpotById,
    getCurrentSpot,
    isLoading,
    getError,
    fetchSpots,
    fetchSpot,
    createSpot,
    updateSpot,
    deleteSpot,
    setSpots,
    setCurrentSpot,
  };
});
