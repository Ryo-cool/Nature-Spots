<template>
  <div>
    <v-tabs v-model="selectedSeason" align-tabs="center" color="primary">
      <v-tab v-for="key in seasonKeys" :key="key" :value="key">
        {{ $t(`spot.seasonal.${key}`) }}
      </v-tab>
    </v-tabs>

    <div v-if="loading" class="d-flex justify-center my-6">
      <v-progress-circular indeterminate />
    </div>

    <div v-else-if="error" class="text-center my-6 text-error">
      {{ $t("spot.seasonal.error") }}
    </div>

    <div
      v-else-if="spots.length === 0"
      class="text-center my-6 text-medium-emphasis"
    >
      {{ $t("spot.seasonal.empty") }}
    </div>

    <v-slide-group v-else v-model="selectedIndex" show-arrows>
      <template #prev>
        <v-btn icon="mdi-arrow-left-circle-outline" variant="text" />
      </template>
      <template #next>
        <v-btn icon="mdi-arrow-right-circle-outline" variant="text" />
      </template>

      <v-slide-group-item v-for="spot in spots" :key="spot.id">
        <v-card
          class="ma-4"
          :height="300"
          :width="300"
          :to="`/spots/${spot.id}`"
        >
          <v-img
            :src="spot.photo?.url || '/no-image.png'"
            :aspect-ratio="12 / 9"
            cover
          />
          <v-card-text>
            <h3 class="text-h6">{{ spot.name }}</h3>
            <div class="d-flex align-center mt-2">
              <v-icon size="small" class="mr-1">mdi-leaf</v-icon>
              <span>{{ $t(`spot.seasonal.${selectedSeason}`) }}</span>
            </div>
          </v-card-text>
        </v-card>
      </v-slide-group-item>
    </v-slide-group>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue";
import { useApi } from "~/composables/useApi";
import {
  useCurrentSeason,
  type SeasonKey,
} from "~/composables/useCurrentSeason";

interface SeasonalSpot {
  id: number;
  name: string;
  photo?: {
    url: string;
  };
  seasons?: { id: number; key: string; name_ja: string }[];
}

interface SeasonalResponse {
  spots: SeasonalSpot[];
  season: { id: number; key: string; name_ja: string };
}

const $api = useApi();
const { getCurrentSeasonKey, seasonKeys } = useCurrentSeason();

const selectedSeason = ref<SeasonKey>(getCurrentSeasonKey());
const selectedIndex = ref<number | null>(null);
const spots = ref<SeasonalSpot[]>([]);
const loading = ref(false);
const error = ref(false);

const fetchSeasonalSpots = async (season: SeasonKey) => {
  loading.value = true;
  error.value = false;
  try {
    const res = await $api.get<SeasonalResponse>(
      `/api/v1/spots/seasonal?season=${season}`,
    );
    spots.value = Array.isArray(res.data?.spots) ? res.data.spots : [];
  } catch (e) {
    console.error("季節別スポットの取得に失敗しました:", e);
    error.value = true;
    spots.value = [];
  } finally {
    loading.value = false;
  }
};

watch(selectedSeason, (key) => {
  fetchSeasonalSpots(key);
});

onMounted(() => {
  fetchSeasonalSpots(selectedSeason.value);
});

defineExpose({
  selectedSeason,
  spots,
  loading,
  error,
  fetchSeasonalSpots,
});
</script>
