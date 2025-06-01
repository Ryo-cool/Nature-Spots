<template>
  <v-app-bar :height="64" color="white">
    <nuxt-link to="/" class="text-decoration-none">
      <app-logo />
    </nuxt-link>

    <app-title class="hidden-mobile-and-down" />

    <v-spacer />
    <signup-link />
    <login-link />
  </v-app-bar>
</template>

<script setup lang="ts">
// App bar height is now fixed at 64px for consistency
// Can be made configurable if needed
</script>
