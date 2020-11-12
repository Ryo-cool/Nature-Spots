<template>
  <div>
  投稿一覧
  <v-list-item
  v-for="review in user"
  :key="review"
  
  >
  <v-card class="mb-2">
    
    <!-- ユーザーの投稿 -->
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
          <div class="indigo--text caption d-flex"><h3>{{ $auth.user.name }}</h3>さんの口コミ（{{ review.created_at }})</div>
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
              :value="review.rating"
              background-color="purple lighten-3"
              color="purple"
              medium
              readonly
              half-increments
            ></v-rating>
            <span class="grey--text subtitle-1 mt-2 ml-1">
              {{ review.rating }}
            </span>
          </v-row>
          <v-card-title>{{ review.title }}</v-card-title>
          <v-card-text>{{ review.text }}</v-card-text>
          <v-card-subtitle>訪問時期:{{ review.wentday }}月</v-card-subtitle>
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
  </v-card>
  </v-list-item>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  data (){
    return{
      rating: 3,
      user: {}
    }
  },
  mounted(){
    this.$axios
      .get(`/api/v1/users/user_data`)
      .then((res) => {
        // const spot = res.data
        this.user = res.data.review
        // this.review = res.data.review
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>