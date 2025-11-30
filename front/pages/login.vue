<template>
  <bef-login-form-card>
    <template #form-card-content>
      <toast-notification />
      <v-form v-model="isValid">
        <user-form-email v-model="params.auth.email" no-validation />
        <user-form-password v-model="params.auth.password" no-validation />
        <v-card-actions>
          <nuxt-link to="#" class="body-2 text-decoration-none">
            パスワードを忘れた?
          </nuxt-link>
        </v-card-actions>
        <v-card-text class="px-0">
          <v-btn
            :disabled="!isValid || loading"
            :loading="loading"
            block
            color="myblue"
            class="text-white"
            @click="login"
          >
            ログインする
          </v-btn>
          <v-btn
            block
            :loading="loading"
            color="success"
            class="mt-4"
            @click="guestLogin"
          >
            ゲストログイン
          </v-btn>
        </v-card-text>
      </v-form>
    </template>
  </bef-login-form-card>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import type { FetchError } from "ofetch";
import { useAuth } from "~/composables/useAuth";
import { useSecureStorage } from "~/composables/useSecureStorage";
import { useToastStore } from "~/stores/toast";
import type { User } from "~/types";

definePageMeta({
  layout: "beforeLogin",
});

const { login: authLogin } = useAuth();
const toastStore = useToastStore();
const router = useRouter();
const config = useRuntimeConfig();
const secureStorage = useSecureStorage();

const isValid = ref(false);
const loading = ref(false);
const params = reactive({
  auth: { email: "", password: "" },
});
interface AuthResponse {
  token: string;
  exp: number;
  user: User | null;
}

const isAuthResponse = (data: unknown): data is AuthResponse => {
  if (!data || typeof data !== "object") return false;
  const candidate = data as Partial<AuthResponse>;
  return (
    typeof candidate.token === "string" &&
    typeof candidate.exp === "number" &&
    ("user" in candidate
      ? candidate.user === null || typeof candidate.user === "object"
      : true)
  );
};

const guestParams = computed(() => ({
  auth: {
    email: config.public.guestEmail,
    password: config.public.guestPassword,
  },
}));

// ログイン処理
async function login() {
  loading.value = true;
  if (isValid.value) {
    try {
      const response = await $fetch<AuthResponse>("/api/v1/user_token", {
        method: "POST",
        body: params,
        baseURL: config.public.apiBaseUrl,
      });
      if (!isAuthResponse(response)) {
        throw new Error("認証レスポンスの形式が不正です");
      }
      await authSuccessful(response);
    } catch (error: unknown) {
      authFailure(error);
    }
  }
  loading.value = false;
}

// ゲストログイン処理
async function guestLogin() {
  loading.value = true;
  try {
    if (!config.public.guestEmail || !config.public.guestPassword) {
      toastStore.showToast({
        message: "ゲストログインが設定されていません",
        color: "error",
      });
      return;
    }

    const response = await $fetch<AuthResponse>("/api/v1/user_token", {
      method: "POST",
      body: guestParams.value,
      baseURL: config.public.apiBaseUrl,
    });
    if (!isAuthResponse(response)) {
      throw new Error("認証レスポンスの形式が不正です");
    }
    await authSuccessful(response);
  } catch (error: unknown) {
    authFailure(error);
  } finally {
    loading.value = false;
  }
}

// ログイン成功処理
async function authSuccessful(response: AuthResponse) {
  await authLogin(response);

  // 保存されたルートパスを取得
  const savedRoute = secureStorage.getItem<string>("rememberRoute");
  const redirectTo = savedRoute ?? "/";

  router.push(redirectTo);
}

// ログイン失敗処理
function authFailure(error: unknown) {
  const fetchError = error as FetchError | undefined;

  if (fetchError?.response?.status === 404) {
    toastStore.showToast({
      message: "ユーザーが見つかりません😷",
      color: "error",
    });
    return;
  }

  toastStore.showToast({
    message: "ログインに失敗しました",
    color: "error",
  });
}

defineExpose({
  login,
  guestLogin,
  params,
  isValid,
  loading,
});
</script>
