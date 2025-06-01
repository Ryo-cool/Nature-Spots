<template>
  <picture>
    <source
      v-if="webpSupported && webpSrc"
      :srcset="webpSrcset"
      :sizes="sizes"
      type="image/webp"
    />
    <source :srcset="originalSrcset" :sizes="sizes" :type="originalType" />
    <img
      :src="fallbackSrc"
      :alt="alt"
      :width="width"
      :height="height"
      :loading="loading"
      class="optimized-image"
      :class="className"
    />
  </picture>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import type { ImageProps } from "~/types/components/common";

interface Props extends ImageProps {
  className?: string;
  webpSrc?: string;
  srcset?: string;
  webpSrcset?: string;
  originalType?: string;
  loading?: "lazy" | "eager";
}

const props = defineProps<Props>();
const webpSupported = ref(false);

// 画像フォーマットのサポート確認
onMounted(async () => {
  if (process.client) {
    const { $imageOptimization } = useNuxtApp();
    if ($imageOptimization) {
      webpSupported.value = $imageOptimization.checkWebPSupport();
    } else {
      // フォールバック: canvas要素を使用してWebPサポートを確認
      const canvas = document.createElement("canvas");
      if (canvas.toDataURL("image/webp").indexOf("data:image/webp") === 0) {
        webpSupported.value = true;
      }
    }
  }
});

// 計算プロパティ
const fallbackSrc = computed(() => props.src);
const originalSrcset = computed(() => props.srcset || props.src);
</script>

<style scoped>
.optimized-image {
  max-width: 100%;
  height: auto;
  display: block;
}
</style>
