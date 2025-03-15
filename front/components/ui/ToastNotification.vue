<template>
  <v-snackbar 
    v-model="isVisible" 
    :color="toastStore.color" 
    :timeout="toastStore.timeout"
    location="top"
  >
    {{ toastStore.message }}
    <template #actions>
      <v-btn variant="text" @click="closeToast">
        Close
      </v-btn>
    </template>
  </v-snackbar>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount } from 'vue'
import { useToastStore } from '~/stores/toast'

const toastStore = useToastStore()

const isVisible = computed({
  get: () => toastStore.show,
  set: (value: boolean) => {
    if (!value) {
      closeToast()
    }
  }
})

function closeToast() {
  toastStore.clearToast()
}

// コンポーネントがアンマウントされる前にトーストをクリア
onBeforeUnmount(() => {
  closeToast()
})
</script>