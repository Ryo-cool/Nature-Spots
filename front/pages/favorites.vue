<template>
  <v-container>
    お気に入りのスポット
    <v-row>
      <v-col v-for="(favorite, index) in fspots" :key="index" cols="6">
        <v-card :to="`/spots/${favorite.id}`">
          <v-img :src="favorite.photo?.url" />
          <v-card-title>{{ favorite.name }}</v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

interface FavoriteSpot {
  id: number;
  name: string;
  photo?: {
    url: string;
  };
}

interface UserDataResponse {
  favorites?: FavoriteSpot[];
}

const $api = useApi();
const toastStore = useToastStore();
const fspots = ref<FavoriteSpot[]>([]);

onMounted(async () => {
  try {
    const res = await $api.get<UserDataResponse>("/api/v1/users/user_data");
    fspots.value = res.data.favorites || [];
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "お気に入りの取得に失敗しました",
      color: "error",
    });
  }
});
</script>
