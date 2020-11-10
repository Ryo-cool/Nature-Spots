<template>
  <v-card class="mt-5">
  <v-list-item
  v-for="review in reviews"
  :key="reviews.id"
  
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
          <div class="indigo--text caption d-flex"><h3>木村ヒロシ</h3>さんが口コミを投稿しました（{{ review.created_at | moment }}）</div>
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
          <v-row>
            <v-rating
              v-model="rating"
              background-color="purple lighten-3"
              color="purple"
              medium
              readonly
              half-increments
            ></v-rating>
            <span class="grey--text subtitle-1 mt-2 ml-1">
              ({{ rating }})
            </span>
          </v-row>
          <v-card-title>{{review.title}}</v-card-title>
          <v-card-text>{{review.text}}</v-card-text>
          <v-card-subtitle>訪問時期:{{review.wentday}}月</v-card-subtitle>
        </v-col>
      </v-row>
      <!-- ライクボタン -->
      <v-row>
        <v-col
          cols="1"
        >
          <v-btn
            icon
            @click="like(review.id)"
          >
            <v-icon>mdi-thumb-up-outline</v-icon>
          </v-btn>
          
        </v-col>
        <v-col
          cols="1"
        >
          <v-btn
            icon
            @click="deleteLike(review.id)"
          >
            <v-icon>mdi-thumb-up</v-icon>
          </v-btn>

        </v-col>
      </v-row>
    <v-divider class="mt-4"></v-divider>
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
      reviews: {},
      users: {},
      likes: []
    }
  },
  filters: {
      moment: function (date) {
          return moment(date).format('YYYY/MM/DD ');
      }
  },
  mounted () {
    this.$axios.get(`/api/v1/spots/${this.$route.params.id}`)
    .then((res) => {
        this.reviews = res.data.review
        
    })
    .catch((error) => {
      console.error(error)
    })
  },

  methods: {
    like(reviewId){
      this.$axios.post(
        `/api/v1/spots/${this.$route.params.id}/reviews/${reviewId}/likes`,
      {
        user_id: this.$auth.user.id,
        review_id: reviewId
      })
      .then(res => {
        console.log(res)
        this.$set(this.reviews, "likes", res.data.likes)
      })
      .catch(error => {
        console.log(error)
      })
    },
    deleteLike(reviewId) {
      this.$axios
        .delete(`/api/v1/spots/${this.$route.params.id}/reviews/${reviewId}/likes/${this.$auth.user.id}`, {
          params: {
            user_id: this.$auth.user.id,
            review_id: this.reviewId
          }
        })
        .then(res => {
          console.log(res)
          // $set を使って this.topic の要素を更新。
          this.$set(this.reviews, "likes", res.data.likes)
        })
        .catch(error => {
          console.log(error)
        })
    }
  }
}
</script>