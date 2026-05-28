import { storeToRefs } from "pinia";
import { useI18n } from "vue-i18n";
import { useNotificationStore } from "~/stores/notification";
import type { AppNotification } from "~/types/api/notification";

/**
 * 通知ストアのラッパ。表示用メッセージ生成と遷移先の解決を提供する。
 */
export const useNotifications = () => {
  const store = useNotificationStore();
  const { items, unreadCount, loading, hasUnread, hasMore } =
    storeToRefs(store);
  const { t } = useI18n();

  // action に応じた表示メッセージを生成
  const buildMessage = (notification: AppNotification): string => {
    const actorName = notification.actor?.name ?? t("notification.someone");
    switch (notification.action) {
      case "review_posted":
        return t("notification.reviewPosted", { actor: actorName });
      case "followed":
        return t("notification.followed", { actor: actorName });
      case "announcement":
        return notification.notifiable?.type === "announcement"
          ? notification.notifiable.title
          : t("notification.announcement");
      default:
        return "";
    }
  };

  // クリック時の遷移先を解決（遷移不要なら null）
  const linkFor = (notification: AppNotification): string | null => {
    const notifiable = notification.notifiable;
    if (!notifiable) return null;
    switch (notifiable.type) {
      case "review":
        return `/spots/${notifiable.spot_id}`;
      case "relationship":
        return `/user/${notifiable.user_id}`;
      case "announcement":
        return "/notifications";
      default:
        return null;
    }
  };

  return {
    items,
    unreadCount,
    loading,
    hasUnread,
    hasMore,
    buildMessage,
    linkFor,
    fetch: store.fetch,
    fetchMore: store.fetchMore,
    fetchUnreadCount: store.fetchUnreadCount,
    markAsRead: store.markAsRead,
    markAllRead: store.markAllRead,
  };
};
