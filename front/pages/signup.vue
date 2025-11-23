<template>
  <bef-login-form-card>
    <template #form-card-content>
      <toast-notification />
      <v-form ref="formRef" v-model="isValid">
        <user-form-name v-model="params.user.name" />
        <user-form-email v-model="params.user.email" />
        <user-form-password v-model="params.user.password" />
        <v-btn
          :disabled="!isValid || loading"
          :loading="loading"
          block
          color="myblue"
          class="white--text"
          @click="signup"
        >
          登録する
        </v-btn>
      </v-form>
    </template>
  </bef-login-form-card>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import type { FetchError } from "ofetch";
import { useAuth } from "~/composables/useAuth";
import { useToastStore } from "~/stores/toast";
import type { User } from "~/types";

definePageMeta({
  layout: "beforeLogin",
});

interface SignupParams {
  user: {
    name: string;
    email: string;
    password: string;
  };
}

interface AuthResponse {
  token: string;
  exp: number;
  user: User | null;
}

interface ApiErrorResponse {
  message?: string;
  errors?: Record<string, string[] | string>;
}

const router = useRouter();
const config = useRuntimeConfig();
const toastStore = useToastStore();
const { login: authLogin } = useAuth();

const isValid = ref(false);
const loading = ref(false);
const formRef = ref<{ reset: () => void } | null>(null);
const params = reactive<SignupParams>({
  user: {
    name: "",
    email: "",
    password: "",
  },
});

const isAuthResponse = (data: unknown): data is AuthResponse => {
  if (!data || typeof data !== "object") return false;
  const candidate = data as Partial<AuthResponse>;
  return (
    typeof candidate.token === "string" &&
    typeof candidate.exp === "number" &&
    (candidate.user === null || typeof candidate.user === "object")
  );
};

const extractErrorMessage = (error: unknown): string => {
  const fetchError = error as FetchError<ApiErrorResponse> | undefined;
  const fromErrors = (() => {
    const errors = fetchError?.data?.errors;
    if (!errors) return null;
    const firstKey = Object.keys(errors)[0];
    const value = errors[firstKey];
    if (Array.isArray(value)) return value[0];
    if (typeof value === "string") return value;
    return null;
  })();

  return (
    fromErrors ||
    fetchError?.data?.message ||
    (fetchError?.message ?? "登録に失敗しました")
  );
};

const resetForm = () => {
  formRef.value?.reset();
  params.user = { name: "", email: "", password: "" };
};

const signup = async () => {
  if (!isValid.value || loading.value) return;

  loading.value = true;

  try {
    // ユーザー作成
    await $fetch("/api/v1/users", {
      method: "POST",
      body: params.user,
      baseURL: config.public.apiBaseUrl,
    });

    // 作成後、自動ログイン
    const authResponse = await $fetch<AuthResponse>("/api/v1/user_token", {
      method: "POST",
      body: {
        auth: { email: params.user.email, password: params.user.password },
      },
      baseURL: config.public.apiBaseUrl,
    });

    if (!isAuthResponse(authResponse)) {
      throw new Error("認証レスポンスの形式が不正です");
    }

    await authLogin(authResponse);
    toastStore.showToast({
      message: "アカウントを作成しました",
      color: "success",
    });
    await router.push("/spots");
    resetForm();
  } catch (error: unknown) {
    const message = extractErrorMessage(error);
    toastStore.showToast({ message, color: "error" });
  } finally {
    loading.value = false;
  }
};

defineExpose({ signup, params, isValid, loading });
</script>
