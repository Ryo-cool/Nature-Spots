<template>
  <v-card>
    <v-container>
      <v-row>
        <v-col cols="5">
          <h1>口コミ</h1>
        </v-col>
        <v-col cols="5">
          <nuxt-link
            v-if="spot"
            :to="`${spot.id}/reviews/new`"
            class="text-decoration-none"
          >
            <v-btn color="primary"> 口コミを書く </v-btn>
          </nuxt-link>
        </v-col>
      </v-row>
      <v-divider />
      <v-row>
        <v-col>
          <h4>評価</h4>
          <span v-if="rating >= 4">とても良い</span>
          <span v-else-if="rating >= 3">良い</span>
          <span v-else-if="rating >= 2">普通</span>
          <span v-else>改善が必要</span>
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import type { Ref } from "vue";

interface Spot {
  id: number;
  name: string;
}

const route = useRoute();
const { $api } = useNuxtApp();

const spot: Ref<Spot | null> = ref(null);
const prefecture = ref("");
const location = ref("");
const rating = ref(2.6);
const reviews = ref(0);

onMounted(async () => {
  try {
    const res = await $api.get(`/api/v1/spots/${route.params.id}`);
    spot.value = res.data.spot;
    prefecture.value = res.data.prefecture?.attributes?.name || "";
    location.value = res.data.location?.attributes?.name || "";
    rating.value = res.data.average_rating || 2.6;
    reviews.value = res.data.reviews_count || 0;
  } catch (error) {
    console.error("スポット情報の取得に失敗しました:", error);
  }
});
</script>
