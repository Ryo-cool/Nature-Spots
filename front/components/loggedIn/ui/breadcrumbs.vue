<template>
  <v-breadcrumbs :items="items">
    <template #title="{ item }">
      <nuxt-link v-if="item.to" :to="item.to">{{ item.title }}</nuxt-link>
      <span v-else>{{ item.title }}</span>
    </template>
    <template #divider>
      <v-icon>mdi-chevron-right</v-icon>
    </template>
  </v-breadcrumbs>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();

// ページタイトルのマッピング
const pageTitles: Record<string, string> = {
  index: "ホーム",
  "spots-id": "スポット詳細",
  "spots-id-reviews-new": "レビュー投稿",
  favorites: "お気に入り",
  newspots: "スポット追加",
  "user-id": "ユーザーページ",
  account: "アカウント",
  "account-settings": "アカウント設定",
  "account-password": "パスワード変更",
  "account-userEdit": "プロフィール編集",
  "location-id": "ジャンル",
  "prefecture-id": "都道府県",
};

const items = computed(() => {
  const routeName = route.name as string;
  const title = pageTitles[routeName] || routeName;
  return [
    { title: "HOME", to: "/" },
    { title, to: undefined },
  ];
});
</script>
