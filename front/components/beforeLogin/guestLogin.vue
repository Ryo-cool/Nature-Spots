<template>
  <div>
    <v-btn outlined dark class="font-weight-bold" @click="guestLogin">
      ゲストログイン
    </v-btn>
  </div>
</template>

<script>
export default {
  data() {
    return {
      guestParams: {
        auth: { email: "user0@example.com", password: "password" },
      },
    }
  },
  methods: {
    async guestLogin() {
      await this.$axios
        .$post("/api/v1/user_token", this.guestParams)
        .then((response) => this.authSuccessful(response))
        .catch((error) => this.authFailure(error))
    },
    // ログイン成功
    async authSuccessful(response) {
      await this.$auth.login(response)
      this.$router.go({ path: this.$router.currentRoute.path, force: true })
    },
    // ログイン失敗
    authFailure({ response }) {
      if (response.status === 404) {
        this.$store.dispatch("getToast", { msg: "ユーザーが見つかりません😷" })
      }
    },
  },
}
</script>
