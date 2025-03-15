<template>
  <v-container>
    <v-row>
      <v-col>
        <v-img :src="homeImg" alt="homeImg" aspect-ratio="2.3" contain>
          <v-container fill-height class="px-0">
            <h1>行き先は？</h1>
            <v-row justify="center" align="center">
              <v-col cols="11" sm="9" md="7">
                <spot-search />
              </v-col>
            </v-row>
          </v-container>
        </v-img>
      </v-col>
    </v-row>
    <v-row class="mt-6">
      <japan-list />
      <japan />
      <category />
    </v-row>
    <v-row>
      <v-col>
        <h1>人気のスポット一覧</h1>
        <popular-spots />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import homeImg from "~/assets/images/loggedIn/adventure__isometric.png";

// 認証状態に応じてレイアウトを動的に設定
const { loggedIn } = useAuth()

definePageMeta({
  layout: () => {
    return loggedIn.value ? "loggedIn" : "welcome";
  }
})
</script>

<style>
* {
  font-family: "Kosugi Maru", sans-serif;
  font-weight: 100;
}
</style>