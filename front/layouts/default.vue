<template>
  <v-app>
    <logged-in-app-bar />
    <v-main>
      <v-container>
        <slot />
      </v-container>
    </v-main>
    <logged-in-footer />
  </v-app>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: "auth",
});
</script>
