<template>
  <v-container>
    <v-divider class="my-8"></v-divider>
    <v-row>
      <v-col cols="12" sm="4">
        <v-img
        src="https://picsum.photos/id/103/960/540"
        ></v-img>
        <div class="my-3 headline">従業員に食事を提供する</div>
      </v-col>
      <v-col cols="12" sm="4">
        <v-img
        src="https://picsum.photos/id/536/960/540"
        ></v-img>
        <div class="my-3 headline">レストランの料理をお客様へお届け</div>
      </v-col>
      <v-col cols="12" sm="4">
        <v-img
        src="https://picsum.photos/id/331/960/540"
        ></v-img>
        <div class="my-3 headline">Uber Eats で配達する</div>
      </v-col>
    </v-row>
    <v-row justify="center">
      <v-col cols="1">
        <v-btn>ログイン</v-btn>
      </v-col>
      <v-col cols="1">
        <v-btn>新規登録</v-btn>
      </v-col>
    </v-row>
    <v-row justify="center">
      <v-col cols="2">
        <v-btn>ゲストログイン</v-btn>
      </v-col>
    </v-row>
    <v-divider class="my-8"></v-divider>
  </v-container>
</template>

<script>
export default {
}
</script>