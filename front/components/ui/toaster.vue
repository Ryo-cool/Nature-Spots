<template>
  <v-snackbar
    v-model="isVisible"
    location="top"
    :color="toastStore.color"
    :timeout="toastStore.timeout"
  >
    {{ toastStore.message }}
    <template #actions>
      <v-btn variant="text" @click="toastStore.hideToast"> 閉じる </v-btn>
    </template>
  </v-snackbar>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount } from "vue";
import { useToastStore } from "~/stores/toast";

const toastStore = useToastStore();

const isVisible = computed({
  get: () => toastStore.visible,
  set: (val: boolean) => {
    if (!val) {
      toastStore.hideToast();
    }
  },
});

onBeforeUnmount(() => {
  // ページ遷移前にトーストを削除
  toastStore.hideToast();
});
</script>
