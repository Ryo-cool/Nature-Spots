<template>
  <v-card>
    <!-- ユーザーの投稿 -->
    <v-container>
      投稿一覧
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
          <div class="indigo--text caption d-flex"><h3>木村ヒロシ</h3>さんが口コミを投稿しました（2019年6月）</div>
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
              3.5
            </span>
          </v-row>
          <v-card-title>タイトル</v-card-title>
          <v-card-text>内容</v-card-text>
          <v-card-subtitle>訪問時期:月</v-card-subtitle>
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
      <v-divider class="mt-4"></v-divider>
    </v-container>
  </v-card>
</template>

<script>
export default {
  data (){
    return{
      rating: 3,
    }
  }
}
</script>