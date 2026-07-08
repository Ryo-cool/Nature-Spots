<template>
  <v-container>
    <NuxtPage />
  </v-container>
</template>

<script setup lang="ts">
definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

const route = useRoute();
if (route.name === "account") {
  await navigateTo("/");
}
</script>
