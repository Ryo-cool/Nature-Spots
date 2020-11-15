<template>
  <div>
      <v-card>
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
              <div class="indigo--text caption d-flex"><h3>山口</h3>さんの口コミ（2019年5月)</div>
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
              <v-card-title>〇〇公園</v-card-title>
              <v-row>
                <v-rating
                  :value="3"
                  background-color="purple lighten-3"
                  color="purple"
                  medium
                  readonly
                  half-increments
                ></v-rating>
                <span class="grey--text subtitle-1 mt-2 ml-1">
                  4
                </span>
              </v-row>
              <v-card-title>素敵</v-card-title>
              <v-card-text>よかった</v-card-text>
              <v-card-subtitle>訪問時期:1月</v-card-subtitle>
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
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
}
</script>