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
        this.photo = res.data.spot.photo.url

      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>