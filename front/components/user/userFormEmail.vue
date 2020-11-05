<template>
  <v-text-field
    v-model="setEmail"
    :rules="rules"
    label="メールアドレスを入力"
    :placeholder="form.placeholder"
    outlined
  />
</template>

<script>
export default {
  props: {
    noValidation: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      setEmail: "",
      rules: [
        v => !!v || '',
        v => /.+@.+\..+/.test(v) || ''
      ]
    }
  },
  computed: {
    form () {
      const placeholder = this.noValidation ? undefined : 'your@email.com'
      return { placeholder }
    }
  }
}
</script>