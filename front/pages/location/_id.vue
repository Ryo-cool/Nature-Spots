<template>
  <v-container>
    {{spot.name}}のスポット一覧
    <v-row>
      <v-col 
        v-for="(jspot, index) in jspots"
        :key="index"
        cols="12"
        sm="4"
        >
        <v-card>
          <nuxt-link
          :to="$my.spotLinkTo(jspot.id)"
          class="text-decoration-none"
          >
            <v-img
            src="https://picsum.photos/id/1036/960/540"
            ></v-img>
            <v-card-title>{{ jspot.name }}</v-card-title>
            <v-card-text v-text="jspot.introduction"/>
          </nuxt-link>
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