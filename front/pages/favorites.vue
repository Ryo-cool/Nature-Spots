<template>
  <v-container>
    お気に入りのスポット
    <v-row>
      <v-col v-for="(favorite, index) in fspots" :key="index" cols="6">
        <v-card :to="`/spots/${favorite.id}`">
          <v-img :src="favorite.photo.url" />
          <v-card-title>{{ favorite.name }}</v-card-title>
        </v-card>
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
      fspots: {},
    };
  },
  mounted() {
    this.$axios.get("/api/v1/users/user_data").then((res) => {
      if (res.data) {
        this.fspots = res.data.favorite;
      }
    });
  },
};
</script>
