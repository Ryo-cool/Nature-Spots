<template>

  <v-container  class="grey lighten-2">
    <v-breadcrumbs
    divider="-"
    >
    </v-breadcrumbs>

    <v-row>
      <v-col>
        <carousel />
      </v-col>
    </v-row>
    <v-row>
      <v-col
      cols="12"
      md="6"
      >
      <spot-data />
      </v-col>
      <v-col
        cols="12"
        md="6"
      >
        <review-header />
        <reviews />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      spot: {},
      reviews: {}
    }
  },
  layout ({ $auth }) {
    return $auth.loggedIn ? 'loggedIn' : 'welcome'
  },
  mounted () {
    this.$axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        const spot = res.data.spot
        this.spot = spot
        this.reviews = res.data.review
      }) 
      .catch((error) => {
        console.error(error)
      })
  }
  
}
</script>
