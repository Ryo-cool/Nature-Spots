<template>
  <v-container class="my-7">
    <v-row justify="center">
      <v-col cols="11" md="7" sm="8">
        <h1 class="text-center">口コミを投稿する</h1>
        <h2>総合評価</h2>
        <v-divider class="mb-2" />
        <v-rating
          v-model="rating"
          bg-color="purple-lighten-3"
          color="purple"
          size="large"
          hover
        />
        <h2>口コミ</h2>
        <v-divider class="mb-4" />
        <h4>タイトル(◯文字以内)</h4>
        <v-text-field
          v-model="title"
          placeholder="感想や思い出に残ったことをまとめましょう"
          variant="outlined"
        />
        <h4>内容(◯文字以内)</h4>
        <v-textarea
          v-model="text"
          variant="outlined"
          placeholder="日本でも有名な温泉街で、日帰りで友人と車で出かけました。着いた時から硫黄の香りと湯けむりで、ワクワクしました。なにより温泉街はとても心地よく、浴衣でまち歩きをしながら食べたり、お店にも立ち寄ったりすることができます。温泉にもゆっくり浸かることができ、大満足でした。"
        />
        <h2>写真</h2>
        <v-divider class="mb-4" />
        <v-img :src="preview" max-width="300" />
        <v-file-input
          accept="image/png, image/jpeg, image/bmp"
          show-size
          counter
          label="File input"
          @update:model-value="setImage"
        />
        <h2>行った時期</h2>
        <v-divider class="mb-4" />
        <v-row justify="center">
          <v-date-picker v-model="picker" type="month" locale="ja" />
        </v-row>
        <v-divider class="mb-2" />
        <v-row justify="center">
          <v-btn
            color="primary"
            min-width="300"
            :disabled="!allInput"
            :loading="loading"
            @click="createReview"
          >
            投稿する
          </v-btn>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

interface SpotShowResponse {
  spot?: {
    id: number;
  };
  id?: number;
}

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const $api = useApi();
const toastStore = useToastStore();

const rating = ref<number | undefined>(undefined);
const title = ref("");
const text = ref("");
const picker = ref("");
const image = ref<File | null>(null);
const preview = ref("");
const spotId = ref<number | null>(null);
const loading = ref(false);

const allInput = computed(() => {
  return Boolean(
    title.value && text.value && picker.value && rating.value !== undefined,
  );
});

const setImage = (value: File | File[] | null) => {
  const file = Array.isArray(value) ? value[0] : value;
  if (!file) {
    image.value = null;
    preview.value = "";
    return;
  }
  image.value = file;
  preview.value = URL.createObjectURL(file);
};

const createReview = async () => {
  if (!authStore.user?.id || spotId.value == null || rating.value === undefined)
    return;

  loading.value = true;
  try {
    const formData = new FormData();
    formData.append("title", title.value);
    formData.append("text", text.value);
    if (image.value) {
      formData.append("image", image.value);
    }
    formData.append("wentday", picker.value);
    formData.append("rating", String(rating.value));
    formData.append("spot_id", String(spotId.value));
    formData.append("user_id", String(authStore.user.id));

    await $api.post(`/api/v1/spots/${route.params.id}/reviews/`, formData);
    router.push("/");
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "口コミの投稿に失敗しました",
      color: "error",
    });
  } finally {
    loading.value = false;
  }
};

onMounted(async () => {
  try {
    const res = await $api.get<SpotShowResponse>(
      `/api/v1/spots/${route.params.id}`,
    );
    spotId.value = res.data.spot?.id ?? res.data.id ?? null;
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "スポット情報の取得に失敗しました",
      color: "error",
    });
  }
});
</script>

<style>
h2 {
  margin: 15px 0 3px 0;
}
</style>
