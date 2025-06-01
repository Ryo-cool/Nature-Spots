<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>

<script setup lang="ts">
// タイトルとメタタグの設定
useHead({
  titleTemplate: (titleChunk: string | undefined) => {
    return titleChunk ? `${titleChunk} - Nature Spots` : "Nature Spots";
  },
  meta: [
    { charset: "utf-8" },
    { name: "viewport", content: "width=device-width, initial-scale=1" },
    {
      name: "description",
      content: "Discover beautiful nature spots around you",
    },
  ],
  link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
});
</script>

<style>
body {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>
