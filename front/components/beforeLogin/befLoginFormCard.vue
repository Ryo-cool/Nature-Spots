<template>
  <v-container fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" class="my-8 text-center">
        <h1 class="text-h5 font-weight-bold">
{{ appName }}に{{ pageTitle }}
</h1>
      </v-col>

      <v-card
        flat
        tile
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

<script>
export default {
  data({ $route, $config: { appName } }) {
    return {
      appName,
      pageTitle: this.$t(`pages.${$route.name}`),
    };
  },
};
</script>
