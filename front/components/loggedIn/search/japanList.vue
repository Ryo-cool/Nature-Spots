<template>
  <v-col cols="12" md="7" class="hidden-ipad-and-up">
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-list>
        <v-list-group v-model="isExpanded">
          <template #activator="{ props }">
            <v-list-item v-bind="props">
              <v-list-item-title>都道府県一覧</v-list-item-title>
            </v-list-item>
          </template>

          <v-list-item
            v-for="prefecture in prefectures"
            :key="prefecture.attributes?.id"
            :to="`/prefecture/${prefecture.attributes?.id}`"
          >
            <v-list-item-title>
              {{ prefecture.attributes?.name }}
            </v-list-item-title>
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-card>
  </v-col>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useApi } from "~/composables/useApi";

interface Prefecture {
  attributes: {
    id: number;
    name: string;
  };
}

const $api = useApi();

const prefectures = ref<Prefecture[]>([]);
const isExpanded = ref(true);

onMounted(async () => {
  try {
    const res = await $api.get("/api/v1/prefectures");
    prefectures.value = res.data || [];
  } catch (error) {
    console.error("都道府県データの取得に失敗しました:", error);
  }
});
</script>
