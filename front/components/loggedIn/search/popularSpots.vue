<template>
  <v-slide-group
    v-model="model"
    prev-icon="mdi-arrow-left-circle-outline"
    next-icon="mdi-arrow-right-circle-outline"
  >
    <v-slide-item v-for="(spot, index) in pspots" :key="index">
      <v-card
        class="ma-4"
        height="300"
        width="300"
        nuxt
        :to="`/spots/${spot.id}`"
      >
        <v-img :src="spot.photo.url" :aspect-ratio="12 / 9" />
        <h3>{{ spot.name }}</h3>
        <div>
          <v-icon>mdi-comment-text-outline</v-icon>
          {{ spot.review_count }}件
        </div>
      </v-card>
    </v-slide-item>
  </v-slide-group>
</template>

<script>
import axios from "~/plugins/axios";

export default {
  data: () => ({
    model: null,
    pspots: {},
  }),
  mounted() {
    this.$axios
      .get("api/v1/spots/ranking")
      .then((res) => {
        this.pspots = res.data;
      })
      .catch((error) => {
        console.error(error);
      });
  },
};
</script>
