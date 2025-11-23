<template>
  <div>
    <v-list-item v-for="review in reviews" :key="review.id">
      <v-card>
        <!-- ユーザーの投稿 -->
        <v-container>
          <v-row>
            <v-col cols="1">
              <v-avatar color="black" size="34" class="my-app-log">
                <span class="white--text text-subtitle-2">
                  {{ review.user?.name?.charAt(0) || "U" }}
                </span>
              </v-avatar>
            </v-col>
            <v-col cols="10">
              <div class="indigo--text caption d-flex">
                <h3>{{ review.user?.name || "ユーザー" }}</h3>
                さんの口コミ（{{ formatDate(review.created_at) }})
              </div>
              <div class="blue-grey--text caption">
                いいね{{ review.likes?.length || 0 }}件
              </div>
            </v-col>
            <v-col cols="1">
              <v-btn :icon="true">
                <v-icon>mdi-dots-horizontal</v-icon>
              </v-btn>
            </v-col>
          </v-row>
          <v-row>
            <v-img
              :src="review.image?.url || 'https://picsum.photos/id/243/960/540'"
              :aspect-ratio="16 / 9"
            />
          </v-row>
          <v-row>
            <v-col>
              <v-row>
                <v-rating
                  v-model="review.rating"
                  bg-color="purple-lighten-3"
                  color="purple"
                  size="default"
                  :readonly="true"
                  :half-increments="true"
                />
                <span class="grey--text subtitle-1 mt-2 ml-1">
                  {{ review.rating }}
                </span>
              </v-row>
              <v-card-title>{{ review.title }}</v-card-title>
              <v-card-text>{{ review.text }}</v-card-text>
              <v-card-subtitle>訪問時期:{{ review.wentday }}月</v-card-subtitle>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="1">
              <v-btn :icon="true">
                <v-icon>mdi-thumb-up-outline</v-icon>
              </v-btn>
            </v-col>
            <v-col cols="1">
              <v-btn :icon="true">
                <v-icon>mdi-export-variant</v-icon>
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-list-item>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { format } from "date-fns";
import { ja } from "date-fns/locale";

interface Review {
  id: number;
  title: string;
  text: string;
  rating: number;
  wentday: number;
  created_at: string;
  user?: {
    name: string;
  };
  image?: {
    url: string;
  };
  likes?: Like[];
}

interface Like {
  id: number;
  user_id?: number;
}

const { $api } = useNuxtApp();

const reviews = ref<Review[]>([]);

const formatDate = (dateString: string) => {
  try {
    return format(new Date(dateString), "yyyy年M月d日", { locale: ja });
  } catch {
    return dateString;
  }
};

onMounted(async () => {
  try {
    const res = await $api.get("/api/v1/users/user_data");
    reviews.value = res.data.like_reviews || [];
  } catch (error) {
    console.error("ユーザーデータの取得に失敗しました:", error);
  }
});
</script>
