<template>
  <v-container fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" class="my-8 text-center">
        <h1 class="text-h5 font-weight-bold">{{ appName }}に{{ pageTitle }}</h1>
      </v-col>

      <v-card
        variant="flat"
        class="ma-2"
        width="80%"
        max-width="320"
        color="transparent"
      >
        <!-- コンテンツを差し込むスロット -->
        <slot name="form-card-content" />
      </v-card>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useRoute } from "vue-router";
import { useI18n } from "vue-i18n";

const route = useRoute();
const { t } = useI18n();
const config = useRuntimeConfig();

const appName = config.public.appName || "Nature-Spots";

const pageTitle = computed(() => {
  const routeName = route.name as string;
  return t(`pages.${routeName}`);
});
</script>
