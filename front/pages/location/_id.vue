<template>
  <v-container>
    <breadcrumbs />
    {{ spot.name }}のスポット一覧

    <v-row>
      <v-col v-for="jspot in jspots" :key="jspot.id" cols="12" sm="4">
        <v-card>
          <nuxt-link
            :to="$my.spotLinkTo(jspot.id)"
            class="text-decoration-none"
          >
            <v-img :src="jspot.photo.url" :aspect-ratio="16 / 9" />
            <!-- <v-card-text>{{ jspot }}</v-card-text> -->
            <v-card-title>{{ jspot.name }}</v-card-title>
            <v-card-text>{{ jspot.introduction }}</v-card-text>
            <v-card-text>{{ prefecture.attributes }}</v-card-text>
            <!-- <v-card-text v-text="jspot.introduction"/> -->
          </nuxt-link>
        </v-card>
      </v-col>
      <v-col v-for="(p, index) in prefecture" :key="index">
        <div>{{ p.name }}</div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  layout({ $auth }) {
    return $auth.loggedIn ? "loggedIn" : "welcome";
  },
  data() {
    return {
      spot: {},
      jspots: [],
      prefecture: [],
    };
  },
  mounted() {
    this.$axios
      .get(`/api/v1/locations/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.location.attributes;
        this.jspots = res.data.spot;
        this.prefecture = res.data.prefecture;
      })
      .catch((error) => {
        console.error(error);
      });
  },
};
</script>
