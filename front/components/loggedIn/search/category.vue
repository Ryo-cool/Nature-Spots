<template>
    <v-col
      cols="12"
      md="5"
    >
      <h1>ジャンルから探す</h1>
      <v-card
      class="mt-4"
      >
        <v-img
          :src="homeImg"
          aspect-ratio="1.3"
          contain
        >
          <v-container>
            <v-row 
              justify="space-between"
              
            >
              <v-col
                cols="12"
                md="6"
                align="center"
                v-for="genre in genre"
                :key="genre.title"
              >
              <nuxt-link
                :to="`location/${genre.attributes.id}`"
                class="text-decoration-none"
              >
                <v-btn
                  outlined
                  color="indigo"
                  width="90%"
                  min-height="100"
                >
                  
                    <h1>{{ genre.attributes.name }}</h1>
                </v-btn>
              </nuxt-link>
              </v-col>
              <!-- <v-col
                cols="12"
                md="6"
                align="center"
              >
                <v-btn
                  outlined
                  color="indigo"
                  width="90%"
                  min-height="100"
                >
                <h1>山</h1>
                </v-btn>
              </v-col>
            </v-row>
            <v-row>
              <v-col
                cols="12"
                md="6"
                align="center"
              >
                <v-btn
                  outlined
                  color="indigo"
                  width="90%"
                  min-height="100"
                >
                <h1>川</h1>
                </v-btn>
              </v-col>
              <v-col
                cols="12"
                md="6"
                align="center"
              >
                <v-btn
                  outlined
                  color="indigo"
                  width="90%"
                  min-height="100"
                >
                <h1>公園</h1>
                </v-btn>
              </v-col> -->
            </v-row>
          </v-container>
        </v-img>
      </v-card>
    </v-col>
</template>

<script>
import homeImg from '~/assets/images/loggedIn/surfing_monochromatic.png'
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      homeImg,
      genre: []
    }
  },
  mounted() {
    axios.get("api/v1/locations")
    .then((res) => {
      this.genre = res.data
    })
    .catch((error) => {
      console.error(error)
    })
  }
}
</script>