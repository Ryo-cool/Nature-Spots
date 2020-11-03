<template>
  <v-container>
    <v-row>
      {{spot.name}}のスポット一覧
      <v-col 
        v-for="jspot in jspots"
        :key="jspot"
        >
        <v-card>
          <v-card-title>
            {{ jspot.name}}
          </v-card-title>
        </v-card>
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
      jspots: []
    }
  },
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },
  mounted () {
    axios
      .get(`/api/v1/locations/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.location.attributes
        this.jspots = res.data.spot
        
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>