<template>
  <v-col
    cols="12"
    md="6"
  >
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-img
        :src="homeImg"
        aspect-ratio="1.3"
        contain
      >
        <v-container>
          <v-row >
            <v-col
              cols="6"
              v-for="prefecture in prefecture"
              :key="prefecture"
            >
            <div>{{ prefecture.name }}</div>
            </v-col>
          </v-row>
        </v-container>
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