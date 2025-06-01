<template>
  <v-app>
    <logged-in-app-bar />
    <v-main>
      <slot />
    </v-main>
    <logged-in-footer />
  </v-app>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: "auth",
});
</script>
