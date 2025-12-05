<template>
  <v-container class="grey lighten-2">
    <v-row>
      <v-col>
        <breadcrumbs />
        <carousel />
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="6">
        <spot-data />
      </v-col>
      <v-col cols="12" md="6">
        <review-header />
        <reviews />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});
</script>
