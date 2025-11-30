<template>
  <v-card class="mb-4">
    <v-container>
      <v-row>
        <v-col cols="12" sm="3">
          <div class="headline pt-3">
            {{ spot?.name }}
          </div>
          <v-snackbar v-model="alert" color="pink" :timeout="2000">
            お気に入り登録
          </v-snackbar>
          <v-snackbar v-model="likeDelete" color="pink" :timeout="2000">
            お気に入り解除しました
          </v-snackbar>
        </v-col>
        <v-col cols="5" sm="4" class="pt-5">
          <v-rating
            v-model="rating"
            bg-color="purple-lighten-3"
            color="purple"
            :readonly="true"
            :half-increments="true"
            size="small"
          />
        </v-col>
        <v-col cols="6" sm="3" class="pt-6">
          <h4>
            {{ rating }}
            <v-icon>mdi-comment-outline</v-icon>({{ reviewCount }})件
          </h4>
        </v-col>

        <v-col cols="" md="5" sm="3" class="pt-5">
          <v-btn
            v-if="isFavorite"
            :icon="true"
            color="pink"
            @click="createFavorite(spot?.id)"
          >
            <v-icon>mdi-heart-outline</v-icon>
          </v-btn>
          <v-btn
            v-else
            :icon="true"
            color="pink"
            @click="deleteFavorite(spot?.id)"
          >
            <v-icon>mdi-heart</v-icon>
          </v-btn>
          <v-btn :icon="true" color="primary">
            <v-icon>mdi-export-variant</v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <v-divider />
      <h3>
        {{ spot?.name }}の説明
        <div class="body-1">
          {{ spot?.introduction }}
        </div>
      </h3>
      <h3>
        都道府県
        <div class="body-1">
          {{ prefecture }}
        </div>
      </h3>
      <h3>
        住所
        <div class="body-1">
          {{ spot?.address }}
        </div>
      </h3>
      <h3>
        ジャンル
        <div class="body-1">
          {{ location }}
        </div>
      </h3>
      <v-row>
        <v-col>
          <GmapMap
            v-if="spot?.latitude && spot?.longitude"
            ref="mapRef"
            :center="{ lat: spot.latitude, lng: spot.longitude }"
            :zoom="12"
            style="width: 100%; height: 300px"
          >
            <GmapMarker
              v-for="(m, id) in markerItems"
              :key="id"
              :position="{ lat: spot.latitude, lng: spot.longitude }"
              :title="m.title"
              :clickable="true"
              :draggable="false"
            />
          </GmapMap>
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import type { Ref } from "vue";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";
import { useApi } from "~/composables/useApi";

interface Spot {
  id: number;
  name: string;
  introduction: string;
  address: string;
  latitude: number;
  longitude: number;
}

interface MarkerItem {
  position: { lat: number; lng: number };
  title: string;
}

const route = useRoute();
const authStore = useAuthStore();
const toastStore = useToastStore();
const $api = useApi();

const spot: Ref<Spot | null> = ref(null);
const favUserId: Ref<number | null> = ref(null);
const prefecture = ref("");
const location = ref("");
const rating = ref(2.6);
const reviewCount = ref(0);
const alert = ref(false);
const likeDelete = ref(false);
const mapRef = ref(null);

const markerItems: Ref<MarkerItem[]> = ref([
  { position: { lat: 35.71, lng: 139.72 }, title: "marker_1" },
]);

const isFavorite = computed(() => {
  if (!authStore.user || !favUserId.value) return true;
  return favUserId.value !== authStore.user.id;
});

const fetchSpotData = async () => {
  try {
    const res = await $api.get(`/api/v1/spots/${route.params.id}`);
    spot.value = res.data.spot;
    prefecture.value = res.data.prefecture?.attributes?.name || "";
    location.value = res.data.location?.attributes?.name || "";
    favUserId.value = res.data.favuser;
    reviewCount.value = res.data.reviews_count || 0;
    rating.value = res.data.average_rating || 2.6;

    if (spot.value?.latitude && spot.value?.longitude) {
      markerItems.value = [
        {
          position: { lat: spot.value.latitude, lng: spot.value.longitude },
          title: spot.value.name,
        },
      ];
    }
  } catch (error) {
    console.error("スポット情報の取得に失敗しました:", error);
    toastStore.showToast({
      message: "スポット情報の取得に失敗しました",
      color: "error",
    });
  }
};

const createFavorite = async (spotId?: number) => {
  if (!spotId || !authStore.user) return;

  try {
    await $api.post(`/api/v1/spots/${route.params.id}/favorites`, {
      user_id: authStore.user.id,
      spot_id: spotId,
    });
    alert.value = true;
    favUserId.value = authStore.user.id;
  } catch (error) {
    console.error("お気に入り登録に失敗しました:", error);
    toastStore.showToast({
      message: "お気に入り登録に失敗しました",
      color: "error",
    });
  }
};

const deleteFavorite = async (spotId?: number) => {
  if (!spotId || !authStore.user) return;

  try {
    await $api.delete(
      `/api/v1/spots/${route.params.id}/favorites/${authStore.user.id}`,
      {
        params: {
          user_id: authStore.user.id,
          spot_id: spotId,
        },
      },
    );
    likeDelete.value = true;
    favUserId.value = null;
  } catch (error) {
    console.error("お気に入り解除に失敗しました:", error);
    toastStore.showToast({
      message: "お気に入り解除に失敗しました",
      color: "error",
    });
  }
};

onMounted(() => {
  fetchSpotData();
});
</script>
