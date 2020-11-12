<template>
  <v-container>
    <v-row  justify="center" align-content="center">
      <v-col cols="10">
        {{ $route.fullPath }}
        <!-- ユーザー情報 -->
        <v-card>
            {{ $auth.user.name }}さん
          <v-container>
            <v-row>
              <v-col cols="2">
                {{ $auth.user.email}}
                画像
              </v-col>
              <v-col cols="8">
                <v-row>
                  <v-col>
                    投稿
                  </v-col>
                  <v-col>
                    フォロー
                  </v-col>
                  <v-col> 
                    フォロワー　
                  </v-col>
                  <v-col>
                    プロフィール編集
                  </v-col>
                </v-row>
              </v-col>
            </v-row>
          </v-container>
        </v-card>
      
        <v-row>
          <v-col cols="7">
            <mypage />
          </v-col>
          <v-col>
            いきたいリスト
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
      user: {}
    }
  },
  mounted(){
    this.$axios
      .get(`/api/v1/users/user_data`)
      .then((res) => {
        // const spot = res.data
        this.user = res.data
        // this.review = res.data.review
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>