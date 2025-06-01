<template>
  <bef-login-form-card>
    <template #form-card-content>
      <v-form v-model="isValid">
        <user-form-name />
        <user-form-email />
        <user-form-password />
        <v-btn
          :disabled="!isValid || loading"
          :loading="loading"
          block
          color="myblue"
          class="white--text"
          @click="signup"
        >
          登録する
        </v-btn>
      </v-form>
    </template>
  </bef-login-form-card>
</template>

<script>
export default {
  layout: "beforeLogin",
  data() {
    return {
      isValid: false,
      loading: false,
      params: { user: { name: "", email: "", password: "" } },
    };
  },
  methods: {
    signup() {
      this.loading = true;
      setTimeout(() => {
        this.formReset();
        this.loading = false;
      }, 1500);
    },
    formReset() {
      this.$refs.form.reset();
      this.params = { user: { name: "", email: "", password: "" } };
    },
  },
};
</script>
