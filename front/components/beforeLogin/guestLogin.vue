<template>
  <div>
    <v-btn
      variant="outlined"
      color="white"
      class="font-weight-bold"
      :loading="isLoading"
      @click="guestLogin"
    >
      ゲストログイン
    </v-btn>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useRouter } from "vue-router";
import type { FetchError } from "ofetch";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";

const router = useRouter();
const authStore = useAuthStore();
const toastStore = useToastStore();
const config = useRuntimeConfig();

const isLoading = ref(false);

const guestCredentials = computed(() => ({
  email: config.public.guestEmail,
  password: config.public.guestPassword,
}));

const guestLogin = async () => {
  if (isLoading.value) return;

  isLoading.value = true;

  try {
    if (!guestCredentials.value.email || !guestCredentials.value.password) {
      toastStore.showToast({
        message: "ゲストログインが設定されていません",
        color: "error",
      });
      return;
    }

    const token = await authStore.login(guestCredentials.value);

    if (token) {
      toastStore.showToast({
        message: "ゲストログインしました",
        color: "success",
      });

      // ホームページにリダイレクト
      await router.push("/");
    } else {
      throw new Error("ログインに失敗しました");
    }
  } catch (error: unknown) {
    console.error("ゲストログインエラー:", error);

    const status = (error as FetchError | undefined)?.response?.status;
    const message =
      status === 404 ? "ユーザーが見つかりません😷" : "ログインに失敗しました";

    toastStore.showToast({
      message,
      color: "error",
    });
  } finally {
    isLoading.value = false;
  }
};
</script>
