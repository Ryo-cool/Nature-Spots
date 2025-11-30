<template>
  <v-col cols="12" sm="4">
    <v-btn v-if="!isFollowing" color="primary" @click="follow">
      フォローする
    </v-btn>
    <v-btn v-else variant="outlined" @click="unFollow"> フォロー解除 </v-btn>
  </v-col>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useRoute } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";
import { useApi } from "~/composables/useApi";

const route = useRoute();
const authStore = useAuthStore();
const toastStore = useToastStore();
const $api = useApi();

const isFollowing = ref(false);

const follow = async () => {
  if (!authStore.user) {
    toastStore.showToast({
      message: "ログインが必要です",
      color: "error",
    });
    return;
  }

  try {
    await $api.post("/api/v1/relationships", {
      user_id: authStore.user.id,
      follow_id: route.params.id,
    });

    isFollowing.value = true;
    toastStore.showToast({
      message: "フォローしました",
      color: "success",
    });
  } catch (error) {
    console.error("フォローに失敗しました:", error);
    toastStore.showToast({
      message: "フォローに失敗しました",
      color: "error",
    });
  }
};

const unFollow = async () => {
  if (!authStore.user) {
    toastStore.showToast({
      message: "ログインが必要です",
      color: "error",
    });
    return;
  }

  try {
    await $api.delete("/api/v1/relationships/delete/", {
      params: {
        user_id: authStore.user.id,
        follow_id: route.params.id,
      },
    });

    isFollowing.value = false;
    toastStore.showToast({
      message: "フォローを解除しました",
      color: "success",
    });
  } catch (error) {
    console.error("フォロー解除に失敗しました:", error);
    toastStore.showToast({
      message: "フォロー解除に失敗しました",
      color: "error",
    });
  }
};

// TODO: 初期フォロー状態を取得する処理を追加
</script>
