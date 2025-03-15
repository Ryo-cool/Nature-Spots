<template>
  <v-text-field
    :model-value="modelValue"
    @update:model-value="updateValue"
    :rules="passwordRules"
    :counter="!noValidation"
    :hint="hint"
    label="パスワードを入力"
    :placeholder="placeholder"
    :hide-details="noValidation"
    :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
    :type="showPassword ? 'text' : 'password'"
    variant="outlined"
    autocomplete="on"
    @click:append="showPassword = !showPassword"
  />
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  noValidation: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

// パスワード表示状態
const showPassword = ref(false)

// バリデーションメッセージ
const min = "8文字以上"
const msg = `${min}。半角英数字•ﾊｲﾌﾝ•ｱﾝﾀﾞｰﾊﾞｰが使えます`

// バリデーションルール
const required = (v: string) => !!v || ""
const format = (v: string) => /^[\w-]{8,72}$/.test(v) || msg

// プロパティに基づいてルールを設定
const passwordRules = computed(() => props.noValidation ? [required] : [format])
const hint = computed(() => props.noValidation ? undefined : msg)
const placeholder = computed(() => props.noValidation ? undefined : min)

// 値の更新
function updateValue(value: string) {
  emit('update:modelValue', value)
}
</script>