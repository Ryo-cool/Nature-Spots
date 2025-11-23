<template>
  <v-text-field
    :model-value="modelValue"
    :rules="rules"
    label="メールアドレスを入力"
    :placeholder="placeholder"
    variant="outlined"
    @update:model-value="updateValue"
  />
</template>

<script setup lang="ts">
import { computed } from "vue";

const props = defineProps({
  modelValue: {
    type: String,
    default: "",
  },
  noValidation: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(["update:modelValue"]);

// バリデーションルール
const rules = [
  (v: string) => !!v || "メールアドレスを入力してください",
  (v: string) =>
    /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(v) ||
    "メールアドレスの形式が正しくありません",
  (v: string) => v.length <= 254 || "メールアドレスが長すぎます",
];

// プレースホルダー
const placeholder = computed(() =>
  props.noValidation ? undefined : "your@email.com",
);

// 値の更新
function updateValue(value: string) {
  emit("update:modelValue", value);
}
</script>
