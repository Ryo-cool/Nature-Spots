<template>
  <v-container>
    <v-row justify="center">
      <v-img
        :src="photo || '/no-image.png'"
        :max-height="460"
        :alt="spotName"
        cover
      />
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { useApi } from "~/composables/useApi";

const route = useRoute();
const $api = useApi();

const photo = ref<string | null>(null);
const spotName = ref("");

onMounted(async () => {
  try {
    const res = await $api.get(`/api/v1/spots/${route.params.id}`);
    photo.value = res.data.spot?.photo?.url || null;
    spotName.value = res.data.spot?.name || "";
  } catch (error) {
    console.error("スポット画像の取得に失敗しました:", error);
  }
});
</script>
