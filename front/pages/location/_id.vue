<template>
  <v-container>
    <v-row>
      <v-col>
        {{spot}}
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from '~/plugins/axios'
export default {
  data () {
    return {
      spot: {}
    }
  },
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },
  mounted () {
    axios
      .get(`/api/v1/locations/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spots
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>