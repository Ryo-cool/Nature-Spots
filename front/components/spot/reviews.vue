<template>
  <v-card class="mt-5">
  <v-list-item
  v-for="review in reviews"
  :key="reviews.id"
  @click=""
  >
    <v-container>

      <v-row>
        <v-col
        cols="1"
        >
        
          <v-avatar
            color="black"
            size="34"
            class="my-app-log"
          >
            <span class="white--text text-subtitle-2">
              Biz
            </span>
          </v-avatar>
        </v-col>
        <v-col
          cols="10"
          
        >
          <div class="indigo--text caption">木村ヒロシさんが口コミを投稿しました（{{ review.created_at | moment }}）</div>
          <div class="blue-grey--text caption">いいね〇〇件</div>
        </v-col>
        <v-col
          cols="1"
          
        >
            <v-btn
              icon
              
            >
              <v-icon>mdi-dots-horizontal</v-icon>
              
            </v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-img
        src="https://picsum.photos/id/243/960/540"
        ></v-img>
      </v-row>
      <v-row>
        <v-col>
          <v-rating
            v-model="rating"
            background-color="purple lighten-3"
            color="purple"
            small
            readonly
          ></v-rating>
          <v-card-title>{{review.title}}</v-card-title>
          <v-card-text>{{review.text}}</v-card-text>
          <v-card-subtitle>訪問時期:{{review.wentday}}月</v-card-subtitle>
        </v-col>
      </v-row>
      <v-row>
        <v-col
          cols="1"
        >
          <v-btn
            icon
          >
            <v-icon>mdi-thumb-up-outline</v-icon>
          </v-btn>
          
        </v-col>
        <v-col
          cols="1"
        >
          <v-btn
            icon
          >
            <v-icon>mdi-export-variant</v-icon>
          </v-btn>

        </v-col>
      </v-row>
      
    </v-container>
    </v-list-item>
  </v-card>
  
</template>

<script>
import axios from '~/plugins/axios'

import moment from 'moment'

export default {
  data() {
    return {
      rating: 3.6,
      items: [
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me 2' },
      ],
      reviews: {}
    }
  },
  filters: {
      moment: function (date) {
          return moment(date).format('YYYY/MM/DD ');
      }
  },
  mounted () {
    axios.get(`/api/v1/spots/${this.$route.params.id}`)
    .then((res) => {
        this.reviews = res.data.review
        
    })
    .catch((error) => {
      console.error(error)
    })
  }
}
</script>