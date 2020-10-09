<template>
  <v-card class="mt-5">
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
          cols="9"
          
        >
          <div class="indigo--text caption">木村ヒロシさんが口コミを投稿しました（10月3日）</div>
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
          <v-card-title>家族みんなで楽しめました！</v-card-title>
          <v-card-text>今年の3月に行ったのですがとても気持ちが良くて快適でした!</v-card-text>
          <v-card-subtitle>訪問時期:4月</v-card-subtitle>
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
</template>

<script>
export default {
  data() {
    return {
      rating: 3.7,
      items: [
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me 2' },
      ],
    }
  }
}
</script>