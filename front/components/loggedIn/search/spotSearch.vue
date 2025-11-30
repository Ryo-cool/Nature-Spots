<template>
  <div>
    <v-autocomplete
      v-model="selectedSpot"
      :items="spots"
      :item-title="(item) => item.name"
      :item-value="(item) => item"
      prepend-inner-icon="mdi-database-search"
      density="comfortable"
      variant="solo-inverted"
      bg-color="green-lighten-4"
      color="black"
      :height="60"
      hide-no-data
      label="入力し、出たスポットをクリック"
      @update:model-value="onSpotSelect"
    >
      <template #item="{ item, props }">
        <v-list-item v-bind="props" :to="`/spots/${item.raw.id}`">
          <template #prepend>
            <v-icon color="green-darken-2">mdi-map-marker</v-icon>
          </template>
        </v-list-item>
      </template>
    </v-autocomplete>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "~/composables/useApi";

interface Spot {
  id: number;
  name: string;
}

const $api = useApi();
const router = useRouter();

const spots = ref<Spot[]>([]);
const selectedSpot = ref<Spot | null>(null);

const onSpotSelect = (spot: Spot | null) => {
  if (spot) {
    router.push(`/spots/${spot.id}`);
  }
};

onMounted(async () => {
  try {
    const res = await $api.get("/api/v1/spots");
    if (res.data?.spots) {
      spots.value = res.data.spots;
    }
  } catch (error) {
    console.error("スポットデータの取得に失敗しました:", error);
  }
});
</script>

<style scoped>
/* Vuetify 3では、コンポーネント名のセレクターは動作しないため削除 */
</style>
