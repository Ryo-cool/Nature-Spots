<template>
  <v-text-field
    v-model="modelValue"
    :rules="rules"
    label="ユーザー名を入力"
    placeholder="あなたの表示名"
    :counter="max"
    :variant="'outlined'"
    @update:model-value="$emit('update:modelValue', $event)"
  />
</template>

<script setup lang="ts">
import { computed } from "vue";

interface Props {
  modelValue?: string;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  "update:modelValue": [value: string];
}>();

const max = 30;

const rules = [
  (v: string) => !!v || "",
  (v: string) =>
    (!!v && max >= v.length) || `${max}文字以内で入力してください`,
];

const modelValue = computed({
  get: () => props.modelValue || "",
  set: (value: string) => emit("update:modelValue", value),
});
</script>
