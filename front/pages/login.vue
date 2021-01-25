<template>
  <bef-login-form-card #form-card-content>
    <toaster />
    <v-form ref="form" v-model="isValid">
      <user-form-email :email.sync="params.auth.email" no-validation />
      <user-form-password :password.sync="params.auth.password" no-validation />
      <v-card-actions>
        <nuxt-link to="#" class="body-2 text-decoration-none">
          パスワードを忘れた?
        </nuxt-link>
      </v-card-actions>
      <v-card-text class="px-0">
        <v-btn
          :disabled="!isValid || loading"
          :loading="loading"
          block
          color="myblue"
          class="white--text"
          @click="login"
        >
          ログインする
        </v-btn>
        <v-btn
          block
          :loading="loading"
          color="success"
          class="mt-4"
          @click="guestLogin"
        >
          ゲストログイン
        </v-btn>
      </v-card-text>
    </v-form>
  </bef-login-form-card>
</template>

<script>
export default {
  layout: "beforeLogin",
  data() {
    return {
      isValid: false,
      loading: false,
      params: { auth: { email: "", password: "" } },
      guestParams: {
        auth: { email: "user0@example.com", password: "password" },
      },
    }
  },
  methods: {
    async login() {
      this.loading = true
      if (this.isValid) {
        await this.$axios
          .$post("/api/v1/user_token", this.params)
          .then((response) => this.authSuccessful(response))
          .catch((error) => this.authFailure(error))
      }
      this.loading = false
    },
    async guestLogin() {
      this.loading = true
      await this.$axios
        .$post("/api/v1/user_token", this.guestParams)
        .then((response) => this.authSuccessful(response))
        .catch((error) => this.authFailure(error))
    },
    // ログイン成功
    async authSuccessful(response) {
      await this.$auth.login(response)
      this.$router.push(this.$store.state.rememberRoute)
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
