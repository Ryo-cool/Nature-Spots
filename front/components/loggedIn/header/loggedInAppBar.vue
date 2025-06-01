<template>
  <v-app-bar density="compact" :elevation="1" color="white">
    <nuxt-link to="/" class="text-decoration-none">
      <app-logo />
    </nuxt-link>

    <app-title />
    <v-spacer />
    <nuxt-link
      to="/favorites"
      class="text-decoration-none mr-4 hidden-ipad-and-down"
    >
      <v-btn variant="outlined" class="font-weight-bold px-2">
        <v-icon color="pink">mdi-heart</v-icon>
        お気に入りスポット
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/favorites"
      class="text-decoration-none mr-4 hidden-ipad-and-up"
    >
      <v-btn variant="outlined" class="font-weight-bold px-2">
        <v-icon color="pink">mdi-heart</v-icon>
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/newspots"
      class="text-decoration-none mr-4 hidden-ipad-and-down"
    >
      <v-btn variant="outlined" class="font-weight-bold px-2">
        <v-icon>mdi-map-marker-plus-outline</v-icon>
        スポットを追加
      </v-btn>
    </nuxt-link>
    <nuxt-link
      to="/newspots"
      class="text-decoration-none mr-4 hidden-ipad-and-up"
    >
      <v-btn variant="outlined" class="font-weight-bold px-2">
        <v-icon>mdi-map-marker-plus-outline</v-icon>
      </v-btn>
    </nuxt-link>
    <v-menu offset-y :max-width="200">
      <template #activator="{ props }">
        <v-btn icon v-bind="props">
          <v-avatar v-if="!userIcon" size="36">
            <v-icon>mdi-account-circle</v-icon>
          </v-avatar>
          <v-avatar v-else size="36">
            <v-img :src="userIcon" />
          </v-avatar>
        </v-btn>
      </template>
      <v-list density="compact">
        <v-list-subheader>ログイン中のユーザー</v-list-subheader>

        <v-list-item>
          <v-list-item-subtitle>
            {{ authStore.user?.name }}
          </v-list-item-subtitle>
        </v-list-item>

        <v-divider />

        <v-list-subheader>アカウント</v-list-subheader>

        <template v-for="(menu, i) in accountMenus" :key="`menu-${i}`">
          <v-divider v-if="menu.divider" />

          <v-list-item :to="menu.to">
            <template #prepend>
              <v-icon :size="22">{{ menu.icon }}</v-icon>
            </template>
            <v-list-item-title>
              {{ menu.title }}
            </v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useAuthStore } from "~/stores/auth";

interface AccountMenu {
  to: string;
  icon: string;
  title: string;
  divider?: boolean;
}

const authStore = useAuthStore();

const userIcon = ref<string>("");

const accountMenus: AccountMenu[] = [
  { to: "/account/settings", icon: "mdi-account-cog", title: "アカウント設定" },
  {
    to: "/account/password",
    icon: "mdi-lock-outline",
    title: "パスワード変更",
  },
  {
    to: "/logout",
    icon: "mdi-logout-variant",
    title: "ログアウト",
    divider: true,
  },
];

onMounted(() => {
  if (authStore.user?.image?.url) {
    userIcon.value = authStore.user.image.url;
  }
});
</script>
