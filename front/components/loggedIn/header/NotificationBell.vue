<template>
  <v-menu offset-y :max-width="360" :close-on-content-click="false">
    <template #activator="{ props }">
      <v-btn
        icon
        v-bind="props"
        :aria-label="$t('notification.bell')"
        class="mr-2"
        @click="onOpen"
      >
        <v-badge
          v-if="hasUnread"
          :content="badgeContent"
          color="error"
          offset-x="2"
          offset-y="2"
        >
          <v-icon>mdi-bell-outline</v-icon>
        </v-badge>
        <v-icon v-else>mdi-bell-outline</v-icon>
      </v-btn>
    </template>

    <v-card width="360" max-height="480" class="overflow-y-auto">
      <notification-list />
      <v-divider />
      <v-card-actions class="justify-center">
        <v-btn variant="text" size="small" to="/notifications">
          {{ $t("notification.viewAll") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-menu>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { useNotifications } from "~/composables/useNotifications";

const MAX_BADGE_COUNT = 99;

const { unreadCount, hasUnread, fetch, fetchUnreadCount } = useNotifications();

const badgeContent = computed(() =>
  unreadCount.value > MAX_BADGE_COUNT
    ? `${MAX_BADGE_COUNT}+`
    : String(unreadCount.value),
);

// メニューを開いたタイミングで一覧を取得
const onOpen = () => {
  fetch();
};

onMounted(() => {
  fetchUnreadCount();
});
</script>
