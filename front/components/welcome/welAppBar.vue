<template>
  <v-app-bar
    app
    :dark="!isScrollPoint"
    :height="appBarHeight"
    :color="toolbarStyle.color"
    :elevation="toolbarStyle.elevation"
  >
    <app-logo />
    <app-title class="hidden-mobile-and-down" />
    <v-spacer />

    <v-toolbar-items class="ml-2 hidden-ipad-and-down">
      <v-btn
        v-for="(menu, i) in menus"
        :key="`menu-btn-${i}`"
        text
        :class="{ 'hidden-sm-and-down': menu.title === 'about' }"
      >
        {{ $t(`menus.${menu.title}`) }}
      </v-btn>
    </v-toolbar-items>
    <guest-login class="hidden-ipad-and-down" />
    <signup-link class="hidden-ipad-and-down" />
    <login-link class="hidden-ipad-and-down" />
    <v-menu bottom offset-y nudge-left="110" nudge-width="100">
      <template #activator="{ on }">
        <v-app-bar-nav-icon class="hidden-ipad-and-up" v-on="on" />
      </template>
      <v-list dense class="hidden-ipad-and-up">
        <v-list-item link to="/signup"> 会員登録 </v-list-item>
        <v-list-item link to="/login"> ログイン </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
export default {
  props: {
    menus: {
      type: Array,
      default: () => [],
    },
    imgHeight: {
      type: Number,
      default: 0,
    },
  },
  data({ $store }) {
    return {
      scrollY: 0,
      appBarHeight: $store.state.styles.beforeLogin.appBarHeight,
    };
  },
  computed: {
    isScrollPoint() {
      return this.scrollY > this.imgHeight - this.appBarHeight;
    },
    toolbarStyle() {
      const color = this.isScrollPoint ? "white" : "transparent";
      const elevation = this.isScrollPoint ? 4 : 0;
      return { color, elevation };
    },
  },
  mounted() {
    window.addEventListener("scroll", this.onScroll);
  },
  beforeUnmount() {
    window.removeEventListener("scroll", this.onScroll);
  },

  methods: {
    onScroll() {
      this.scrollY = window.scrollY;
    },
  },
};
</script>
