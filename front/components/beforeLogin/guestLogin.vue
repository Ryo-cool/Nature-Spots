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
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";

const router = useRouter();
const authStore = useAuthStore();
const toastStore = useToastStore();

const isLoading = ref(false);

const guestCredentials = {
  email: "user0@example.com",
  password: "password",
};

const guestLogin = async () => {
  if (isLoading.value) return;

  isLoading.value = true;

  try {
    const token = await authStore.login(guestCredentials);

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
  } catch (error: any) {
    console.error("ゲストログインエラー:", error);

    const message =
      error?.response?.status === 404
        ? "ユーザーが見つかりません😷"
        : "ログインに失敗しました";

    toastStore.showToast({
      message,
      color: "error",
    });
  } finally {
    isLoading.value = false;
  }
};
</script>
