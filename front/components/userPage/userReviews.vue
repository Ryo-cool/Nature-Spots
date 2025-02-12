<template>
  <div>
    <v-card v-for="r in review" :key="r.id" class="mb-3">
      <!-- ユーザーの投稿 -->
      <v-container>
        <v-row>
          <v-img :src="r.image.url" :aspect-ratio="16 / 9" />
        </v-row>
        <v-row>
          <v-col>
            <v-card-title>{{ r.spot.name }}</v-card-title>
            <v-card-text>
              <v-row>
                <v-rating
                  v-model="r.rating"
                  background-color="purple lighten-3"
                  color="purple"
                  medium
                  readonly
                  half-increments
                />
                <span class="grey--text subtitle-1 mt-2 ml-1">
                  {{ r.rating }}
                </span>
              </v-row>
            </v-card-text>
            <v-card-title>{{ r.title }}</v-card-title>
            <v-card-text>{{ r.text }}</v-card-text>
            <v-card-subtitle>訪問時期:{{ r.wentday }}月</v-card-subtitle>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <v-btn icon>
              <v-icon>mdi-thumb-up-outline</v-icon>
            </v-btn>
            <div class="blue-grey--text caption">いいね〇〇件</div>
          </v-col>
          <v-col cols="3">
            <v-btn icon>
              <v-icon>mdi-export-variant</v-icon>
            </v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      review: {},
    };
  },
  mounted() {
    this.$axios.get(`/api/v1/users/${this.$route.params.id}`).then((res) => {
      this.review = JSON.parse(res.data.reviews);
    });
  },
};
</script>
