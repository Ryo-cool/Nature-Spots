<template>
  <v-col
    cols="12"
    md="7"
  >
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-img
        :src="homeImg"
        aspect-ratio="1.3"
        contain
      >
        <v-container>
          <v-row>
            <v-col
              cols="2"
              v-for="prefecture in prefectures"
              :key="prefecture.name"
              
            >
            <nuxt-link
            :to="`prefecture/${prefecture.attributes.id}`"
            class="text-decoration-none"
            >
              <v-btn
                color="green lighten-4"
                
              >
              {{ prefecture.attributes.name }}</v-btn>
            </nuxt-link>
            </v-col>
          </v-row>
        </v-container>
      </v-img>
    </v-card>
  </v-col>
</template>

<script>
import homeImg from '~/assets/images/loggedIn/japanesemap.png'
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      homeImg,
      prefectures: []
    }
  },
  mounted() {
    axios.get("api/v1/prefectures")
    .then((res) => {
      this.prefectures = res.data
    })
    .catch((error) => {
      console.error(error)
    })
  }
}
</script>

<style>
.pre {
  padding: 12px 0px 2px 6px;
}
</style>