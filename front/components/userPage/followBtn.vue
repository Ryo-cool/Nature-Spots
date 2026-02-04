<template>
  <v-col cols="12" sm="4">
    <v-btn v-if="!isFollowing" color="primary" @click="follow">
      フォローする
    </v-btn>
    <v-btn v-else variant="outlined" @click="unFollow"> フォロー解除 </v-btn>
  </v-col>
</template>

<script setup lang="ts">
import { computed, ref, watch } from "vue";
import { useRoute } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";
import { useApi } from "~/composables/useApi";

type UserId = number | string;

const props = withDefaults(
  defineProps<{
    userId?: UserId | null;
    initialIsFollowing?: boolean;
  }>(),
  {
    userId: null,
    initialIsFollowing: false,
  },
);

const route = useRoute();
const authStore = useAuthStore();
const toastStore = useToastStore();
const $api = useApi();

const isFollowing = ref(props.initialIsFollowing ?? false);

watch(
  () => props.initialIsFollowing,
  (value) => {
    if (typeof value === "boolean") {
      isFollowing.value = value;
    }
  },
);

const targetUserId = computed<UserId | null>(() => {
  const candidate = props.userId ?? route.params.id;
  if (Array.isArray(candidate)) return candidate[0] ?? null;
  if (candidate === null || candidate === undefined) return null;
  return candidate as UserId;
});

const resolveTargetUserId = (): UserId | null => {
  const followId = targetUserId.value;
  if (followId === null || followId === undefined || followId === "") {
    toastStore.showToast({
      message: "フォロー対象のユーザーが見つかりません",
      color: "error",
    });
    return null;
  }
  return followId;
};

const follow = async () => {
  if (!authStore.user) {
    toastStore.showToast({
      message: "ログインが必要です",
      color: "error",
    });
    return;
  }

  const followId = resolveTargetUserId();
  if (!followId) return;

  try {
    await $api.post("/api/v1/relationships", {
      user_id: authStore.user.id,
      follow_id: followId,
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

  const followId = resolveTargetUserId();
  if (!followId) return;

  try {
    const followIdPath = encodeURIComponent(String(followId));
    await $api.delete(`/api/v1/relationships/${followIdPath}`, {
      params: {
        user_id: authStore.user.id,
        follow_id: followId,
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
