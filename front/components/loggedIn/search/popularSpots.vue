<template>
  <v-slide-group v-model="selectedIndex" show-arrows>
    <template #prev>
      <v-btn icon="mdi-arrow-left-circle-outline" variant="text" />
    </template>
    <template #next>
      <v-btn icon="mdi-arrow-right-circle-outline" variant="text" />
    </template>

    <v-slide-group-item v-for="spot in popularSpots" :key="spot.id">
      <v-card class="ma-4" :height="300" :width="300" :to="`/spots/${spot.id}`">
        <v-img
          :src="spot.photo?.url || '/no-image.png'"
          :aspect-ratio="12 / 9"
          cover
        />
        <v-card-text>
          <h3 class="text-h6">{{ spot.name }}</h3>
          <div class="d-flex align-center mt-2">
            <v-icon size="small" class="mr-1">mdi-comment-text-outline</v-icon>
            <span>{{ spot.review_count || 0 }}件</span>
          </div>
        </v-card-text>
      </v-card>
    </v-slide-group-item>
  </v-slide-group>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useApi } from "~/composables/useApi";

interface PopularSpot {
  id: number;
  name: string;
  photo?: {
    url: string;
  };
  review_count?: number;
}

const $api = useApi();

const selectedIndex = ref<number | null>(null);
const popularSpots = ref<PopularSpot[]>([]);

onMounted(async () => {
  try {
    const res = await $api.get("/api/v1/spots/ranking");
    popularSpots.value = Array.isArray(res.data) ? res.data : [];
  } catch (error) {
    console.error("人気スポットの取得に失敗しました:", error);
  }
});
</script>
