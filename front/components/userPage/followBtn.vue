<template>
  <v-col cols="12" sm="4">
    <v-btn @click="follow"> フォローする </v-btn>
    <v-btn @click="unFollow"> フォロー解除 </v-btn>
  </v-col>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  data() {
    return {
      follows: "",
    }
  },
  methods: {
    follow() {
      this.$axios
        .post(`/api/v1/relationships`, {
          user_id: this.$auth.user.id,
          follow_id: this.$route.params.id,
        })
        .then((res) => {
          console.log(res)
          this.$set(this.follow, "likes", res.data.follow_id)
        })
        .catch((error) => {
          console.log(error)
        })
    },
    unFollow() {
      this.$axios
        .delete(`/api/v1/relationships/delete/`, {
          params: {
            user_id: this.$auth.user.id,
            follow_id: this.$route.params.id,
          },
        })
        .then((res) => {
          console.log(res)
          // $set を使って this.topic の要素を更新。
          // this.$set(this.reviews, "likes", res.data.likes)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
