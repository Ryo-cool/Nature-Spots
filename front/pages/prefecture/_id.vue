<template>
  <v-container>
    <breadcrumbs />
    {{ spotName }}のスポット一覧
    <v-row>
      <v-col v-for="(jspot, index) in pspots" :key="index" cols="12" sm="4">
        <v-card>
          <NuxtLink :to="spotLinkTo(jspot.id)" class="text-decoration-none">
            <v-img :src="jspot.photo?.url" :aspect-ratio="12 / 9" />
            <v-card-title>{{ jspot.name }}</v-card-title>
            <v-card-text>{{ jspot.introduction }}</v-card-text>
          </NuxtLink>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { setPageLayout } from "#imports";
import { useAuth } from "~/composables/useAuth";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "welcome",
});

interface SpotItem {
  id: number;
  name: string;
  introduction?: string;
  photo?: {
    url?: string;
  };
}

interface ActiveHashResource {
  id?: number;
  name?: string;
  attributes?: {
    id?: number;
    name?: string;
  };
}

interface PrefectureShowResponse {
  prefecture?: ActiveHashResource;
  spot?: SpotItem[];
}

const route = useRoute();
const { loggedIn } = useAuth();
const $api = useApi();
const toastStore = useToastStore();
const { $my } = useNuxtApp();

const spotName = ref("");
const pspots = ref<SpotItem[]>([]);

const spotLinkTo = (id: number) => {
  return $my?.spotLinkTo(id) ?? `/spots/${id}`;
};

const resolveName = (resource?: ActiveHashResource) => {
  return resource?.attributes?.name || resource?.name || "";
};

onMounted(async () => {
  if (loggedIn.value) {
    setPageLayout("loggedIn");
  }

  try {
    const res = await $api.get<PrefectureShowResponse>(
      `/api/v1/prefectures/${route.params.id}`,
    );
    spotName.value = resolveName(res.data.prefecture);
    pspots.value = res.data.spot || [];
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "スポット一覧の取得に失敗しました",
      color: "error",
    });
  }
});
</script>
