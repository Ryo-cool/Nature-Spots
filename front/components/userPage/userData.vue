<template>
  <v-col cols="12" sm="8">
    <v-row>
      <v-col cols="4" md="3">
        <v-avatar color="orange" size="120">
          <v-img :src="userImage || '/default-avatar.png'" />
        </v-avatar>
      </v-col>
      <v-col col="4" md="5">
        <div class="text-h5 font-weight-bold">{{ user?.name }}</div>
        <div class="mt-2">{{ user?.introduction }}</div>
        <v-row class="mt-7">
          <v-col>
            <div class="text-caption grey--text">投稿</div>
            <div class="text-h6">{{ reviewCount }}件</div>
          </v-col>
          <v-col>
            <div class="text-caption grey--text">フォロー</div>
            <div class="text-h6">{{ followCount }}人</div>
          </v-col>
          <v-col>
            <div class="text-caption grey--text">フォロワー</div>
            <div class="text-h6">{{ followerCount }}人</div>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-col>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { useRoute } from "vue-router";

interface User {
  id: number;
  name: string;
  introduction?: string;
  image?: {
    url: string;
  };
}

const route = useRoute();
const { $api } = useNuxtApp();

const user = ref<User | null>(null);
const userImage = ref<string | null>(null);
const reviews = ref<any[]>([]);
const follow = ref<any[]>([]);
const follower = ref<any[]>([]);

const reviewCount = computed(() => reviews.value.length);
const followCount = computed(() => follow.value.length);
const followerCount = computed(() => follower.value.length);

onMounted(async () => {
  try {
    const res = await $api.get(`/api/v1/users/${route.params.id}`);
    user.value = res.data.user;
    userImage.value = res.data.user?.image?.url || null;

    // レビューデータの処理
    if (res.data.reviews) {
      reviews.value =
        typeof res.data.reviews === "string"
          ? JSON.parse(res.data.reviews)
          : res.data.reviews;
    }

    follow.value = res.data.follow || [];
    follower.value = res.data.follower || [];
  } catch (error) {
    console.error("ユーザーデータの取得に失敗しました:", error);
  }
});
</script>
