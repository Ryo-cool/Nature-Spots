<template>
  <v-app-bar
    :theme="isScrollPoint ? 'light' : 'dark'"
    :height="appBarHeight"
    :color="toolbarStyle.color"
    :elevation="toolbarStyle.elevation"
  >
    <app-logo />
    <app-title class="hidden-mobile-and-down" />
    <v-spacer />

    <div class="ml-2 hidden-ipad-and-down d-flex">
      <v-btn
        v-for="(menu, i) in menus"
        :key="`menu-btn-${i}`"
        variant="text"
        :class="{ 'hidden-sm-and-down': menu.title === 'about' }"
      >
        {{ $t(`menus.${menu.title}`) }}
      </v-btn>
    </div>
    <guest-login class="hidden-ipad-and-down" />
    <signup-link class="hidden-ipad-and-down" />
    <login-link class="hidden-ipad-and-down" />
    <v-menu location="bottom">
      <template #activator="{ props: menuProps }">
        <v-app-bar-nav-icon class="hidden-ipad-and-up" v-bind="menuProps" />
      </template>
      <v-list density="compact" class="hidden-ipad-and-up">
        <v-list-item to="/signup">会員登録</v-list-item>
        <v-list-item to="/login">ログイン</v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from "vue";

interface Menu {
  title: string;
}

interface Props {
  menus?: Menu[];
  imgHeight?: number;
}

const props = withDefaults(defineProps<Props>(), {
  menus: () => [],
  imgHeight: 0,
});

// i18n can be added later for menu translations

const scrollY = ref(0);
const appBarHeight = 64; // Fixed height for consistency

const isScrollPoint = computed(() => {
  return scrollY.value > props.imgHeight - appBarHeight;
});

const toolbarStyle = computed(() => {
  const color = isScrollPoint.value ? "white" : "transparent";
  const elevation = isScrollPoint.value ? 4 : 0;
  return { color, elevation };
});

const onScroll = () => {
  scrollY.value = window.scrollY;
};

onMounted(() => {
  window.addEventListener("scroll", onScroll);
});

onBeforeUnmount(() => {
  window.removeEventListener("scroll", onScroll);
});
</script>
