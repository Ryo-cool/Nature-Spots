<template>
  <v-container>
    <v-form>
      <v-row>
        <v-col cols="3">
          <v-text-field v-model="user.name" label="ユーザー名" />
        </v-col>
        <v-col cols="3">
          <v-text-field v-model="user.introduction" label="自己紹介文" />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="6">
          <v-img :src="preview || undefined" />
          <v-file-input
            chips
            small-chips
            show-size
            label="画像(任意)"
            accept="image/png, image/jpeg, image/bmp"
            prepend-icon="mdi-camera"
            @update:model-value="setImage"
          />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="3">
          <v-btn color="primary" :loading="loading" @click="editUser">
            登録する
          </v-btn>
        </v-col>
      </v-row>
    </v-form>
  </v-container>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

interface UserForm {
  name: string;
  introduction: string;
}

interface UserShowResponse {
  user?: {
    name?: string;
    introduction?: string;
    image?: {
      url?: string;
    };
  };
}

const authStore = useAuthStore();
const $api = useApi();
const router = useRouter();
const toastStore = useToastStore();

const user = reactive<UserForm>({
  name: "",
  introduction: "",
});
const image = ref<File | null>(null);
const preview = ref<string | null>(null);
const loading = ref(false);

const setImage = (value: File | File[] | null) => {
  const file = Array.isArray(value) ? value[0] : value;
  if (!file) {
    image.value = null;
    preview.value = null;
    return;
  }
  image.value = file;
  preview.value = URL.createObjectURL(file);
};

const editUser = async () => {
  if (!authStore.user?.id) return;

  loading.value = true;
  try {
    const formData = new FormData();
    formData.append("name", user.name);
    formData.append("introduction", user.introduction);
    if (image.value) {
      formData.append("image", image.value);
    }

    await $api.put(`/api/v1/users/${authStore.user.id}`, formData);
    router.push("/");
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "プロフィールの更新に失敗しました",
      color: "error",
    });
  } finally {
    loading.value = false;
  }
};

onMounted(async () => {
  if (!authStore.user?.id) return;

  try {
    const res = await $api.get<UserShowResponse>(
      `/api/v1/users/${authStore.user.id}`,
    );
    user.name = res.data.user?.name || "";
    user.introduction = res.data.user?.introduction || "";
    preview.value = res.data.user?.image?.url || null;
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "ユーザー情報の取得に失敗しました",
      color: "error",
    });
  }
});
</script>
