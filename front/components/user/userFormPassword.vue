<template>
  <v-text-field
    v-model="setPassword"
    :rules="form.rules"
    :counter="!noValidation"
    :hint="form.hint"
    label="パスワードを入力"
    :placeholder="form.placeholder"
    :hide-details="noValidation"
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
  computed: {
    form () {
      const min = '8文字以上'
      const msg = `${min}。半角英数字•ﾊｲﾌﾝ•ｱﾝﾀﾞｰﾊﾞｰが使えます`
      const required = v => !!v || ''
      const format = v => /^[\w-]{8,72}$/.test(v) || msg

      const rules = this.noValidation ? [required] : [format]
      const hint = this.noValidation ? undefined : msg
      const placeholder = this.noValidation ? undefined : min
      return { rules, hint, placeholder }
    }
  }
}
</script>