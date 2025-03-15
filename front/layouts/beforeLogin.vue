<template>
  <v-app>
    <bef-login-app-bar />
    <v-main>
      <slot />
    </v-main>
    <bef-login-footer />
  </v-app>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'loggedInRedirects'
})
</script>