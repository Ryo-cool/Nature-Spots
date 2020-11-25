<template>
  <v-container>
    <v-row>
      <v-col cols="8">
        <!-- ユーザー情報 -->
        <v-card>
          <v-container>
            {{ $auth.user.name }}のページ
            <v-row>
              <v-col>
                <v-row>
                  <v-avatar
                    size="120"
                  >
                    <v-img
                      :src="photo"
                      
                    />
                  </v-avatar>
                </v-row>
                <v-row>
                  <v-col>
                  </v-col>
                  <v-col>
                    フォロー
                  </v-col>
                  <v-col> 
                    フォロワー　
                  </v-col>
                  <v-col>
                    <nuxt-link to="userEdit">
                      プロフィール編集
                    </nuxt-link>
                  </v-col>
                  <v-col>
                    {{ user.introduction }}
                  </v-col>
                </v-row>
              </v-col>
            </v-row>
          </v-container>
        </v-card>
        
      </v-col>
      <v-col>
        <v-row>
          <v-col cols="6">
            <mypage />
          </v-col>
          <v-col cols="6">
            いいねした投稿
            <like-review />
          </v-col>
        </v-row> 
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "~/plugins/axios"



export default {
  data (){
    return{
      user: {},
      photo:null
    }
  },
  mounted(){
    this.$axios
      .get(`/api/v1/users/user_data`)
      .then((res) => {
        // const spot = res.data
        this.user = res.data.user
        this.photo = res.data.user.image.url
    
        // this.review = res.data.review
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>