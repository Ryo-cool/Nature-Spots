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
import { useAuth } from "~/composables/useAuth";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";

const router = useRouter();
const authStore = useAuthStore();
const { login: authLogin } = useAuth();
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
    const email = guestCredentials.value.email;
    const password = guestCredentials.value.password;

    if (!email || !password) {
      toastStore.showToast({
        message: "ゲストログインが設定されていません",
        color: "error",
      });
      return;
    }

    const response = await authStore.login({ email, password });

    if (!response) {
      throw new Error("ログインに失敗しました");
    }

    await authLogin(response);
    toastStore.showToast({
      message: "ゲストログインしました",
      color: "success",
    });
    await router.push("/");
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
