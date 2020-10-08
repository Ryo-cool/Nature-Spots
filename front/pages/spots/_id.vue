<template>
  <v-container>
    <v-row>
      <v-col
      cols="12"
      md="6"
      >
        <v-card>
          <p>スポット名:{{spot.name}}</p>
          <p>説明:{{spot.introduction}}</p>
          <p>住所:{{spot.address}}</p>
          <p>都道府県:{{prefecture}}</p>
        </v-card>
      </v-col>
      <v-col
        cols="12"
        md="6"
      >
        <v-btn 
        class="primary"
        >
          口コミを書く
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },
  data () {
    return {
      spot: {},
      prefecture: {}
    }
  },
  computed: {
  },
  mounted () {
    axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spot
        this.prefecture = res.data.prefecture.attributes.name
      })
      .catch((error) => {
        console.error(error)
      })
  }
  
}
</script>
