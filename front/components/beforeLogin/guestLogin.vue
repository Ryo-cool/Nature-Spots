<template>
  <div>
    <v-btn
      outlined
      dark
      :loading="loading"
      class="font-weight-bold"
      @click="guestLogin"
    >
      ゲストログイン
    </v-btn>
  </div>
</template>

<script>
export default {
  data () {
    return {
      loading: false,
      guestParams: { auth: { email: 'user0@example.com', password: 'password' } },
    }
  },
  methods: {
    async guestLogin () {
      this.loading = true
      await this.$axios.$post('/api/v1/user_token', this.guestParams)
        .then(response => this.authSuccessful(response))
    },
    // ログイン成功
    async authSuccessful (response) {
      await this.$auth.login(response)
      this.$router.push(this.$store.state.rememberRoute)
    }
  }
}
</script>