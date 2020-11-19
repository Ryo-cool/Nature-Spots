<template>
  <v-container>
    <v-row justify="center">
      <v-img
        :src="photo"
        max-height="460"
      />
    </v-row>
  </v-container>
</template>


<script>
import axios from '~/plugins/axios'

var URL = "http://localhost:3000"

export default {
  data () {
    return {
      photo: null
    }
  },
  mounted () {
    this.$axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        var img = res.data.spot.photo.url
        this.photo = URL + img
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>