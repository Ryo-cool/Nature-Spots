<template>
  <v-container class="py-6" style="max-width: 720px">
    <div class="d-flex align-center justify-space-between mb-4">
      <h1 class="text-h5">{{ $t("notification.title") }}</h1>
      <v-btn
        v-if="hasUnread"
        variant="text"
        color="primary"
        @click="markAllRead"
      >
        {{ $t("notification.markAllRead") }}
      </v-btn>
    </div>

    <v-card v-if="items.length > 0">
      <v-list>
        <template v-for="(notification, index) in items" :key="notification.id">
          <v-divider v-if="index > 0" />
          <v-list-item
            :class="{ 'bg-blue-lighten-5': !notification.read }"
            @click="onClick(notification)"
          >
            <template #prepend>
              <v-icon :color="iconColor(notification.action)">
                {{ actionIcon(notification.action) }}
              </v-icon>
            </template>
            <v-list-item-title class="text-wrap">
              {{ buildMessage(notification) }}
            </v-list-item-title>
            <v-list-item-subtitle class="text-caption">
              {{ formatDate(notification.created_at) }}
            </v-list-item-subtitle>
          </v-list-item>
        </template>
      </v-list>

      <div v-if="hasMore" class="text-center py-3">
        <v-btn variant="outlined" :loading="loading" @click="fetchMore">
          {{ $t("notification.loadMore") }}
        </v-btn>
      </div>
    </v-card>

    <v-card v-else-if="!loading" class="pa-8 text-center text-medium-emphasis">
      {{ $t("notification.empty") }}
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { onMounted } from "vue";
import { useI18n } from "vue-i18n";
import { useNotifications } from "~/composables/useNotifications";
import type {
  AppNotification,
  NotificationAction,
} from "~/types/api/notification";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

const {
  items,
  loading,
  hasUnread,
  hasMore,
  buildMessage,
  linkFor,
  fetch,
  fetchMore,
  markAsRead,
  markAllRead,
} = useNotifications();
const { locale } = useI18n();
const router = useRouter();

const ACTION_ICONS: Record<NotificationAction, string> = {
  review_posted: "mdi-comment-text-outline",
  followed: "mdi-account-plus-outline",
  announcement: "mdi-bullhorn-outline",
};

const ACTION_COLORS: Record<NotificationAction, string> = {
  review_posted: "teal",
  followed: "indigo",
  announcement: "orange",
};

const actionIcon = (action: NotificationAction): string =>
  ACTION_ICONS[action] ?? "mdi-bell-outline";

const iconColor = (action: NotificationAction): string =>
  ACTION_COLORS[action] ?? "grey";

const formatDate = (value: string): string =>
  new Date(value).toLocaleString(locale.value === "en" ? "en-US" : "ja-JP");

const onClick = async (notification: AppNotification) => {
  if (!notification.read) {
    await markAsRead(notification.id);
  }
  const link = linkFor(notification);
  if (link) {
    router.push(link);
  }
};

onMounted(() => {
  fetch();
});
</script>
