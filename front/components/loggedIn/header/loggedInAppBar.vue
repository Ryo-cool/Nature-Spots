<template>
  <v-app-bar app dense elevation="1" clipped-left color="white">
    <nuxt-link to="/" class="text-decoration-none">
      <app-logo />
    </nuxt-link>

    <app-title />
    <v-spacer />
    <nuxt-link
      to="/favorites"
      class="text-decoration-none mr-4 hidden-ipad-and-down"
    >
      <v-btn outlined class="font-weight-bold px-2">
        <v-icon color="pink"> mdi-heart </v-icon>
        お気に入りスポット
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/favorites"
      class="text-decoration-none mr-4 hidden-ipad-and-up"
    >
      <v-btn outlined class="font-weight-bold px-2">
        <v-icon color="pink"> mdi-heart </v-icon>
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/newspots"
      class="text-decoration-none mr-4 hidden-ipad-and-down"
    >
      <v-btn outlined class="font-weight-bold px-2">
        <v-icon>mdi-map-marker-plus-outline</v-icon>
        スポットを追加
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/newspots"
      class="text-decoration-none mr-4 hidden-ipad-and-up"
    >
      <v-btn outlined class="font-weight-bold px-2">
        <v-icon>mdi-map-marker-plus-outline</v-icon>
      </v-btn>
    </nuxt-link>
    <v-menu app offset-x offset-y max-width="200">
      <template #activator="{ on }">
        <v-btn icon v-on="on">
          <v-avatar v-if="icon == null" size="36">
            <v-icon> mdi-account-circle </v-icon>
          </v-avatar>
          <v-avatar v-else size="36">
            <v-img :src="userIcon" />
          </v-avatar>
        </v-btn>
      </template>
      <v-list dense>
        <v-subheader> ログイン中のユーザー </v-subheader>

        <v-list-item>
          <v-list-item-content>
            <v-list-item-subtitle>
              {{ $auth.user.name }}
            </v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>

        <v-divider />

        <v-subheader> アカウント </v-subheader>

        <template v-for="(menu, i) in accountMenus">
          <v-divider v-if="menu.divider" :key="`menu-divider-${i}`" />

          <v-list-item :key="`menu-list-${i}`" :to="{ name: menu.name }">
            <v-list-item-icon class="mr-2">
              <v-icon size="22" v-text="menu.icon" />
            </v-list-item-icon>
            <v-list-item-title>
              {{ $my.pageTitle(menu.name) }}
            </v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      accountMenus: [
        { name: "account-settings", icon: "mdi-account-cog" },
        { name: "account-password", icon: "mdi-lock-outline" },
        { name: "logout", icon: "mdi-logout-variant", divider: true },
      ],
      userIcon: "",
      icon: null,
    };
  },
  mounted() {
    this.userIcon = this.$auth.user.image.url;
    this.icon = this.userIcon;
  },
};
</script>
<style></style>
