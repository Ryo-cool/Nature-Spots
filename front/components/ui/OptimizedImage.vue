<template>
  <picture>
    <source
      v-if="webpSupported && webpSrc"
      :srcset="webpSrcset"
      :sizes="sizes"
      type="image/webp"
    />
    <source :srcset="originalSrcset" :sizes="sizes" :type="originalType" >
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

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator"
import { ImageProps } from "~/types/components/common"

@Component
export default class OptimizedImage extends Vue implements ImageProps {
  @Prop({ required: true }) src!: string
  @Prop({ default: "" }) alt!: string
  @Prop() width?: number
  @Prop() height?: number
  @Prop({ default: "lazy" }) loading!: "lazy" | "eager"
  @Prop() className?: string
  @Prop() webpSrc?: string
  @Prop() srcset?: string
  @Prop() webpSrcset?: string
  @Prop() sizes?: string
  @Prop() originalType?: string

  private webpSupported = false

  mounted() {
    this.checkWebPSupport()
  }

  get fallbackSrc(): string {
    return this.src
  }

  get originalSrcset(): string {
    return this.srcset || this.src
  }

  private async checkWebPSupport() {
    this.webpSupported = await this.$imageOptimization.checkWebPSupport()
  }
}
</script>

<style scoped>
.optimized-image {
  max-width: 100%;
  height: auto;
  display: block;
}
</style>
