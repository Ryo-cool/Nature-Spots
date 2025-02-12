<template>
  <v-snackbar v-model="setSnackbar" top text>
    {{ toast.msg }}
    <template #action="{ attrs }">
      <v-btn v-bind="attrs" text :color="toast.color" @click="resetToast">
        Close
      </v-btn>
    </template>
  </v-snackbar>
</template>

<script>
export default {
  computed: {
    toast() {
      return this.$store.state.toast;
    },
    setSnackbar: {
      get() {
        return !!this.toast.msg;
      },
      set(val) {
        // timeout: -1の場合は通過しない
        this.resetToast();
        return val;
      },
    },
  },
  beforeDestroy() {
    // ページ遷移前に削除する(-1に対応)
    this.resetToast();
  },
  methods: {
    resetToast() {
      return this.$store.dispatch("getToast", { msg: null });
    },
  },
};
</script>
