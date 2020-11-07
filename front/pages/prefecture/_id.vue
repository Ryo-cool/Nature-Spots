<template>
  <v-container>
    <breadcrumbs />
    {{spot.name}}のスポット一覧
    <v-row>
      <v-col 
        v-for="(jspot ,index) in pspots"
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
      pspots: []
    }
  },
  layout ({ $auth }) {
    return $auth.loggedIn ? 'loggedIn' : 'welcome'
  },
  mounted () {
    this.$axios
      .get(`/api/v1/prefectures/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.prefecture.attributes
        this.pspots = res.data.spot
        
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>