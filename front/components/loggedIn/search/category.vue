<template>
    <v-col
      cols="12"
      md="5"
    >
      <h1>ジャンルから探す</h1>
      <v-card
      class="mt-4"
      >
        <v-container>
          <v-row 
            justify="space-between"
            
          >
            <v-col
              cols="6"
              
              
              align="center"
              v-for="genre in genre"
              :key="genre.id"
            >
            <nuxt-link
              :to="`location/${genre.id}`"
              class="text-decoration-none"
            >
            <v-img
              :src="genre.img"
              gradient="to top right, rgba(44,44,160,.1), rgba(120,178,189,.6)"
              contain
            >
              
              <v-row
                class="fill-height ma-0"
                align="center"
                justify="center"
                >
                <div class="white--text display-3">{{ genre.name }}</div>
              </v-row>
              
            </v-img>
            </nuxt-link>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-col>
</template>

<script>

import axios from '~/plugins/axios'
// 画像インポート
import sea from '~/assets/images/loggedIn/sea.jpg'
import mountain from '~/assets/images/loggedIn/mountain.jpg'
import river from '~/assets/images/loggedIn/river.jpg'
import park from '~/assets/images/loggedIn/park.jpg'
import pond from '~/assets/images/loggedIn/pond.jpg'
import lake from '~/assets/images/loggedIn/lake.jpg'

export default {
  data () {
    return {
      genre: [
        { id: '1',name: "海",img: sea},
        { id: '2',name: "山",img: mountain},
        { id: '3',name: "川",img: river},
        { id: '4',name: "公園",img: park},
        { id: '5',name: "池",img: pond},
        { id: '6',name: "湖",img: lake},
      ],
      // genre:{}
    }
  },
  // mounted() {
  //   this.$axios.get("api/v1/locations")
  //   .then((res) => {
  //     this.genre = res.data
  //   })
  //   .catch((error) => {
  //     console.error(error)
  //   })
  // }
}
</script>

