<template>
  <v-toolbar-title>
    {{ appName }}
  </v-toolbar-title>
</template>

<script setup lang="ts">
const config = useRuntimeConfig();
const appName = config.public.appName || "Nature-Spots";
</script>
