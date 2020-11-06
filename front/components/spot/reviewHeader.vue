<template>
  <v-card
  >
    <v-container>
      <v-row>
        <v-col
        cols="5"
        >
          <h1>
            口コミ
          </h1>
        </v-col>
        <v-col
          cols="5"
        >
        <nuxt-link
        :to="`${spot.id}/reviews/new`"
        class="text-decoration-none"
        >
          <v-btn 
          class="primary"
          >
            口コミを書く
          </v-btn>
        </nuxt-link>
        </v-col>
      </v-row>
      <v-divider></v-divider>
      <v-row>
        <v-col>
          <h4>評価</h4>
          とても良い
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script>
import axios from '~/plugins/axios'
export default {
  data () {
    return {
      spot: {},
      prefecture: {},
      location: {},
      rating: 2.6,
      reviews: 300,
    }
  },
  mounted () {
    this.$axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spot
        this.prefecture = res.data.prefecture.attributes.name
        this.location = res.data.location.attributes.name
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>