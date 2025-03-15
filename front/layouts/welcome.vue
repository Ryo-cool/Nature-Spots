<template>
  <v-app>
    <wel-app-bar :menus="menus" :img-height="imgHeight" />
    <v-img
      dark
      src="https://picsum.photos/id/235/1920/1080?blur=1"
      gradient="to top right, rgba(113,133,122,.6), rgba(68,218,195,.9)"
      :height="imgHeight"
    >
      <v-row
        align="center"
        justify="center"
        :style="{ height: `${imgHeight}px` }"
      >
        <v-col cols="12" class="text-center">
          <h1 class="text-h4 mb-4">
            自然を探そう。ワクワクしよう。
          </h1>
          <h4 class="text-subtitle-1" :style="{ letterSpacing: '5px' }">
            自然スポットに特化した口コミサイト
          </h4>
          <div class="pt-9">
            <guest-login class="ma-2" />
            <signup-link />
            <login-link />
          </div>
        </v-col>
      </v-row>
    </v-img>
    <v-sheet>
      <v-container fluid :style="{ maxWidth: '1280px' }">
        <wel-about />
        <v-row v-for="(menu, i) in menus" :key="`menu-${i}`">
          <v-col cols="12">
            <div :is="`wel-${menu.title}`" />
          </v-col>
        </v-row>
      </v-container>
    </v-sheet>
    <bef-login-footer />
  </v-app>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const menus = ref([
  { title: 'products' },
  { title: 'price' },
  { title: 'company' },
  { title: 'contact' }
])

const imgHeight = ref(690)
</script>