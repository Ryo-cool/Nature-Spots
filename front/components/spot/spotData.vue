<template>
  <v-card>
    <v-container>
      <v-row
      
      >
        <v-col
        cols="12"
        md="10"
        sm="8"
        >
          <v-row
          
          >
            <v-col
            cols="12"
            sm="4"
            >
              <h1>{{spot.name}}
              </h1>
            </v-col>
            <v-col
            cols="5"
            sm="4"
            >
              <v-rating
                v-model="rating"
                background-color="purple lighten-3"
                color="purple"
                readonly
                half-increments
                small
              ></v-rating>
              
            </v-col>
            <v-col cols="6" sm="4" class="pt-4">
              <h4>
                {{ rating }}
                (<v-icon>mdi-comment-outline</v-icon>
                {{ reviews }}件)
              </h4>
              <!-- <span class="color=myblue">
                ({{ rating }})
              </span> -->
            </v-col>
          </v-row>
        </v-col>
        <v-col
        cols=""
        md="2"
        sm="3"
        >
          <v-btn
            icon
            color="pink"
          >
            <v-icon>
              mdi-heart
            </v-icon>
          </v-btn>
          <v-btn
          icon
          color="myblue"
          >
            <v-icon>
              mdi-export-variant
            </v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <v-divider></v-divider>
      <p>{{spot.name}}の説明:{{spot.introduction}}</p>
      <p>住所:{{spot.address}}</p>
      <p>都道府県:{{prefecture}}</p>
      <p>ジャンル:{{location}}</p>
    </v-container>
  </v-card>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      spot: {},
      prefecture: {},
      location: {},
      rating: 2.6,
      reviews: 300,
    }
  },
  mounted () {
    axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spot
        this.prefecture = res.data.prefecture.attributes.name
        this.location = res.data.location.attributes.name
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>