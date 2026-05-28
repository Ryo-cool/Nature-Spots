<template>
  <div>
    <div class="d-flex align-center justify-space-between px-4 py-2">
      <span class="text-subtitle-1 font-weight-bold">
        {{ $t("notification.title") }}
      </span>
      <v-btn
        v-if="hasUnread"
        variant="text"
        size="small"
        color="primary"
        @click="onMarkAllRead"
      >
        {{ $t("notification.markAllRead") }}
      </v-btn>
    </div>

    <v-divider />

    <v-list v-if="items.length > 0" density="compact" class="py-0">
      <v-list-item
        v-for="notification in items"
        :key="notification.id"
        :class="{ 'bg-blue-lighten-5': !notification.read }"
        @click="onClick(notification)"
      >
        <template #prepend>
          <v-icon :color="iconColor(notification.action)" :size="24">
            {{ actionIcon(notification.action) }}
          </v-icon>
        </template>
        <v-list-item-title class="text-wrap text-body-2">
          {{ buildMessage(notification) }}
        </v-list-item-title>
        <v-list-item-subtitle class="text-caption">
          {{ formatDate(notification.created_at) }}
        </v-list-item-subtitle>
      </v-list-item>
    </v-list>

    <div v-else class="px-4 py-6 text-center text-medium-emphasis">
      {{ $t("notification.empty") }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from "vue-i18n";
import { useNotifications } from "~/composables/useNotifications";
import type {
  AppNotification,
  NotificationAction,
} from "~/types/api/notification";

const { items, hasUnread, buildMessage, linkFor, markAsRead, markAllRead } =
  useNotifications();
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
  new Date(value).toLocaleDateString(locale.value === "en" ? "en-US" : "ja-JP");

const onClick = async (notification: AppNotification) => {
  if (!notification.read) {
    await markAsRead(notification.id);
  }
  const link = linkFor(notification);
  if (link) {
    router.push(link);
  }
};

const onMarkAllRead = async () => {
  await markAllRead();
};
</script>
