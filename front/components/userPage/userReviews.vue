<template>
  <div>
    <v-card v-for="r in reviews" :key="r.id" class="mb-3">
      <!-- ユーザーの投稿 -->
      <v-container>
        <v-row>
          <v-img
            :src="r.image?.url || '/no-image.png'"
            :aspect-ratio="16 / 9"
            cover
          />
        </v-row>
        <v-row>
          <v-col>
            <v-card-title>{{ r.spot?.name }}</v-card-title>
            <v-card-text>
              <v-row>
                <v-rating
                  v-model="r.rating"
                  bg-color="purple-lighten-3"
                  color="purple"
                  size="default"
                  :readonly="true"
                  :half-increments="true"
                />
                <span class="grey--text subtitle-1 mt-2 ml-1">
                  {{ r.rating }}
                </span>
              </v-row>
            </v-card-text>
            <v-card-title>{{ r.title }}</v-card-title>
            <v-card-text>{{ r.text }}</v-card-text>
            <v-card-subtitle>訪問時期:{{ r.wentday }}月</v-card-subtitle>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <v-btn :icon="true">
              <v-icon>mdi-thumb-up-outline</v-icon>
            </v-btn>
            <div class="blue-grey--text caption">
              いいね{{ r.likes?.length || 0 }}件
            </div>
          </v-col>
          <v-col cols="3">
            <v-btn :icon="true">
              <v-icon>mdi-export-variant</v-icon>
            </v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { useApi } from "~/composables/useApi";

interface Review {
  id: number;
  title: string;
  text: string;
  rating: number;
  wentday: number;
  image?: {
    url: string;
  };
  spot?: {
    name: string;
  };
  likes?: Like[];
}

interface Like {
  id: number;
  user_id?: number;
}

const route = useRoute();
const $api = useApi();

const reviews = ref<Review[]>([]);

onMounted(async () => {
  try {
    const res = await $api.get(`/api/v1/users/${route.params.id}`);
    // レスポンスの形式を確認して適切に処理
    if (res.data.reviews) {
      reviews.value =
        typeof res.data.reviews === "string"
          ? JSON.parse(res.data.reviews)
          : res.data.reviews;
    }
  } catch (error) {
    console.error("ユーザーレビューの取得に失敗しました:", error);
  }
});
</script>
