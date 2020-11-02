<template>
  <v-container>
    {{ $route.fullPath }}
    <v-row  justify="center" align-content="center">
      <v-col cols="10">
        <!-- ユーザー情報 -->
        <v-card>
          <v-container>
            <v-row>
              <v-col cols="2">
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
export default {
}
</script>