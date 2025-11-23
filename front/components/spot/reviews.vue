<template>
  <v-card class="mt-5">
    <v-list-item v-for="review in reviews" :key="review.id">
      <v-container>
        <v-row>
          <v-col cols="2" sm="1" class="pt-3 pl-1">
            <nuxt-link :to="`/user/${review.user.id}`">
              <v-avatar color="black" size="42">
                <v-img :src="review.user.image.url" />
              </v-avatar>
            </nuxt-link>
          </v-col>
          <v-col cols="9">
            <div class="indigo--text caption d-flex">
              <h3>{{ review.user.name }}</h3>
              さんが口コミを投稿しました（{{ formatDate(review.created_at) }}）
            </div>
            <div class="blue-grey--text caption">
              いいね{{ review.likes.length }}件
            </div>
          </v-col>
          <v-col cols="1">
            <v-btn icon>
              <v-icon>mdi-dots-horizontal</v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-img :src="review.image.url" :aspect-ratio="16 / 9" />
        <v-row class="mt-3">
          <v-rating
            v-model="review.rating"
            background-color="purple lighten-3"
            color="purple"
            medium
            readonly
            half-increments
          />
          <span class="grey--text subtitle-1 mt-2 ml-1">
            {{ review.rating }}
          </span>
        </v-row>
        <h2>{{ review.title }}</h2>
        <div class="my-2">
          {{ review.text }}
        </div>
        <div class="grey--text subtitle-1">訪問時期:{{ review.wentday }}月</div>
        <!-- ライクボタン -->
        <v-row>
          <v-col cols="1">
            <v-btn icon @click="like(review.id)">
              <v-icon>mdi-thumb-up-outline</v-icon>
            </v-btn>
          </v-col>
          <v-col cols="1">
            <v-btn icon @click="deleteLike(review.id)">
              <v-icon>mdi-thumb-up</v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-divider class="mt-4" />
      </v-container>
    </v-list-item>
  </v-card>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { format } from "date-fns";
import { ja } from "date-fns/locale";
import { useAuthStore } from "~/stores/auth";

interface Like {
  id: number;
  user_id?: number;
}

interface Review {
  id: number;
  title: string;
  text: string;
  rating: number;
  wentday: number;
  created_at: string;
  image: {
    url: string;
  };
  user: {
    id: number;
    name: string;
    image: {
      url: string;
    };
  };
  likes: Like[];
}

const route = useRoute();
const config = useRuntimeConfig();
const authStore = useAuthStore();

const reviews = ref<Review[]>([]);

onMounted(async () => {
  try {
    const response = await $fetch<{ review: string }>(
      `/api/v1/spots/${route.params.id}`,
      {
        method: "GET",
        baseURL: config.public.apiBaseUrl,
      },
    );
    reviews.value = JSON.parse(response.review) as Review[];
  } catch (error: unknown) {
    console.error("Failed to load reviews", error);
  }
});

const formatDate = (date: string): string => {
  return format(new Date(date), "yyyy/MM/dd", { locale: ja });
};

const like = async (reviewId: number): Promise<void> => {
  try {
    const response = await $fetch<{ likes: Like[] }>(
      `/api/v1/spots/${route.params.id}/reviews/${reviewId}/likes`,
      {
        method: "POST",
        body: {
          user_id: authStore.user?.id,
          review_id: reviewId,
        },
        baseURL: config.public.apiBaseUrl,
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
      },
    );

    const review = reviews.value.find((r) => r.id === reviewId);
    if (review) {
      review.likes = response.likes;
    }
  } catch (error: unknown) {
    console.log(error);
  }
};

const deleteLike = async (reviewId: number): Promise<void> => {
  try {
    const response = await $fetch<{ likes: Like[] }>(
      `/api/v1/spots/${route.params.id}/reviews/${reviewId}/likes/${authStore.user?.id}`,
      {
        method: "DELETE",
        baseURL: config.public.apiBaseUrl,
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
      },
    );

    const review = reviews.value.find((r) => r.id === reviewId);
    if (review) {
      review.likes = response.likes;
    }
  } catch (error: unknown) {
    console.log(error);
  }
};
</script>
