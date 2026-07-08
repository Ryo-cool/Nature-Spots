<template>
  <v-card class="mt-10">
    <v-toolbar flat color="green-lighten-4">
      <v-avatar size="120">
        <v-img :src="photo || undefined" />
      </v-avatar>
      <v-toolbar-title class="ml-4">
        {{ authStore.user?.name }}さん
      </v-toolbar-title>
      <NuxtLink to="userEdit" class="text-decoration-none">
        <v-btn class="ml-5" rounded>
          <v-icon>mdi-pencil</v-icon>
          プロフィール編集
        </v-btn>
      </NuxtLink>
    </v-toolbar>

    <v-tabs v-model="tab">
      <v-tab value="reviews">
        <v-icon start>mdi-account</v-icon>
        投稿したレビュー({{ myReview.length }})
      </v-tab>
      <v-tab value="liked">
        <v-icon start>mdi-heart</v-icon>
        いいねしたレビュー({{ reviews.length }})
      </v-tab>
      <v-tab value="favorites">
        <v-icon start>mdi-access-point</v-icon>
        お気に入りスポット({{ likeSpot.length }})
      </v-tab>
      <v-tab value="followings">
        <v-icon start>mdi-account-multiple</v-icon>
        フォロー ({{ followUser.length }})
      </v-tab>
      <v-tab value="followers">
        <v-icon start>mdi-account-multiple</v-icon>
        フォロワー ({{ follower.length }})
      </v-tab>
    </v-tabs>

    <v-tabs-window v-model="tab">
      <v-tabs-window-item value="reviews">
        <v-row class="mx-2">
          <v-col v-for="s in myReview" :key="s.id" cols="12" md="4" sm="6">
            <v-card>
              <v-img :src="s.image?.url" :aspect-ratio="12 / 9" />
              <NuxtLink
                :to="`/spots/${s.spot?.id}`"
                class="text-decoration-none"
              >
                <v-card-title class="pb-0">
                  {{ s.spot?.name }}
                </v-card-title>
              </NuxtLink>
              <v-card-text class="pb-1">
                <v-row>
                  <v-rating v-model="s.rating" readonly />
                  <span class="text-grey text-body-1 mr-2 pt-2">
                    ({{ s.rating }})
                  </span>
                </v-row>
              </v-card-text>
              <v-card-title class="py-1">
                {{ s.title }}
              </v-card-title>
              <v-card-text>{{ s.text }}</v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-tabs-window-item>

      <v-tabs-window-item value="liked">
        <v-row>
          <v-col v-for="i in reviews" :key="i.id" cols="12" md="4" sm="6">
            <v-card>
              <v-card-text>
                <v-row>
                  <v-col cols="2" class="py-0">
                    <NuxtLink
                      :to="`/user/${i.user?.id}`"
                      class="text-decoration-none"
                    >
                      <v-avatar size="36">
                        <v-img :src="i.user?.image?.url" />
                      </v-avatar>
                    </NuxtLink>
                  </v-col>
                  <v-col>
                    <div>{{ i.user?.name }}さんの投稿</div>
                  </v-col>
                </v-row>
              </v-card-text>
              <v-img :src="i.image?.url" :aspect-ratio="12 / 9" />
              <NuxtLink
                :to="`/spots/${i.spot?.id}`"
                class="text-decoration-none"
              >
                <v-card-title class="pb-0">
                  {{ i.spot?.name }}
                </v-card-title>
              </NuxtLink>
              <v-card-text class="pb-1">
                <v-row>
                  <v-rating v-model="i.rating" readonly />
                  <span class="text-grey text-body-1 mr-2 pt-2">
                    ({{ i.rating }})
                  </span>
                </v-row>
              </v-card-text>
              <v-card-title>{{ i.title }}</v-card-title>
              <v-card-text>{{ i.text }}</v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-tabs-window-item>

      <v-tabs-window-item value="favorites">
        <v-card flat>
          <v-card-text v-for="a in likeSpot" :key="a.id">
            <v-img
              :src="a.photo?.url"
              :aspect-ratio="16 / 9"
              max-height="200"
              max-width="250"
            />
            <NuxtLink :to="`/spots/${a.id}`" class="text-decoration-none">
              <v-card-title>{{ a.name }}</v-card-title>
            </NuxtLink>
          </v-card-text>
        </v-card>
      </v-tabs-window-item>

      <v-tabs-window-item value="followings">
        <v-card flat>
          <v-card-text v-for="v in followUser" :key="v.id">
            <v-avatar size="100">
              <v-img :src="v.image?.url" />
            </v-avatar>
            <NuxtLink :to="`/user/${v.id}`" class="text-decoration-none">
              <v-card-title>{{ v.name }}</v-card-title>
            </NuxtLink>
            <follow-btn :user-id="v.id" :initial-is-following="true" />
          </v-card-text>
        </v-card>
      </v-tabs-window-item>

      <v-tabs-window-item value="followers">
        <v-card flat>
          <v-card-text v-for="t in follower" :key="t.id">
            <v-avatar size="100">
              <v-img :src="t.image?.url" />
            </v-avatar>
            <NuxtLink :to="`/user/${t.id}`" class="text-decoration-none">
              <v-card-title>{{ t.name }}</v-card-title>
            </NuxtLink>
            <follow-btn
              :user-id="t.id"
              :initial-is-following="isFollowingUser(t.id)"
            />
          </v-card-text>
        </v-card>
      </v-tabs-window-item>
    </v-tabs-window>
  </v-card>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useAuthStore } from "~/stores/auth";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

interface ImageUrl {
  url?: string;
}

interface SpotSummary {
  id: number;
  name: string;
}

interface UserSummary {
  id: number;
  name: string;
  image?: ImageUrl;
}

interface ReviewItem {
  id: number;
  title: string;
  text: string;
  rating: number;
  image?: ImageUrl;
  spot?: SpotSummary;
  user?: UserSummary;
}

interface FavoriteSpot {
  id: number;
  name: string;
  photo?: ImageUrl;
}

interface UserDataResponse {
  user?: UserSummary & { image?: ImageUrl };
  reviews?: ReviewItem[];
  liked_reviews?: ReviewItem[];
  favorites?: FavoriteSpot[];
  followings?: UserSummary[];
  followers?: UserSummary[];
}

const authStore = useAuthStore();
const $api = useApi();
const toastStore = useToastStore();

const tab = ref("reviews");
const reviews = ref<ReviewItem[]>([]);
const myReview = ref<ReviewItem[]>([]);
const likeSpot = ref<FavoriteSpot[]>([]);
const followUser = ref<UserSummary[]>([]);
const follower = ref<UserSummary[]>([]);
const photo = ref<string | null>(null);

const isFollowingUser = (userId: number) => {
  return followUser.value.some((user) => user.id === userId);
};

onMounted(async () => {
  try {
    const res = await $api.get<UserDataResponse>("/api/v1/users/user_data");
    photo.value = res.data.user?.image?.url || null;
    reviews.value = res.data.liked_reviews || [];
    myReview.value = res.data.reviews || [];
    likeSpot.value = res.data.favorites || [];
    followUser.value = res.data.followings || [];
    follower.value = res.data.followers || [];
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "ユーザーデータの取得に失敗しました",
      color: "error",
    });
  }
});
</script>
