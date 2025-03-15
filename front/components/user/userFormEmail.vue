<template>
  <v-text-field
    :model-value="modelValue"
    @update:model-value="updateValue"
    :rules="rules"
    label="メールアドレスを入力"
    :placeholder="placeholder"
    variant="outlined"
  />
</template>

<script setup lang="ts">
import { computed } from 'vue'

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

// バリデーションルール
const rules = [(v: string) => !!v || '', (v: string) => /.+@.+\..+/.test(v) || '']

// プレースホルダー
const placeholder = computed(() => props.noValidation ? undefined : 'your@email.com')

// 値の更新
function updateValue(value: string) {
  emit('update:modelValue', value)
}
</script>