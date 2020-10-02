<template>
  <v-text-field
    v-model="setName"
    :rules="rules"
    label="ユーザー名を入力"
    placeholder="あなたの表示名"
    :counter="max"
    outlined
  />
</template>

<script>
export default {
  data () {
    const max = 30
    return {
      max,
      rules: [
        v => !!v || '',
        v => (!!v && max >= v.length) || `${max}文字以内で入力してください`
      ]
    }
  },
}
</script>