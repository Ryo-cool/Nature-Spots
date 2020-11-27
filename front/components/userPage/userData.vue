<template>
  <v-col cols="12" sm="8">
    <v-row>
      <v-col cols="4" md="3">
        <v-avatar
          color="orange"
          size="120"
        >
        <v-img :src="userImage"></v-img>
        </v-avatar>
      </v-col>
      <v-col col="4" md="5">
        <div>{{ user.name }}</div>
        <div>{{ user.introduction }}</div>
        <v-row class="mt-7">
          <v-col>
            <div>投稿</div>
            <div>{{ review.length }}件</div>
          </v-col>
          <v-col>
            <div>フォロー</div>
            <div>{{ follow.length }}人</div>
          </v-col>
          <v-col>
            <div>フォロワー</div>
            <div>{{ follower.length }}人</div>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-col>
</template>

<script>
export default {
  data(){
    return{
      user: {},
      userImage: null,
      review: {},
      follow: {},
      follower: {}
    }
  },
  mounted(){
    this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
    .then((res) => {
      this.user = res.data.user
      this.userImage = res.data.user.image.url
      this.review = JSON.parse(res.data.reviews)
      this.follow = res.data.follow
      this.follower = res.data.follower
    })
  }
}
</script>

