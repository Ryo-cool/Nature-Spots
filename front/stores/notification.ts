import { defineStore } from "pinia";
import { useAuthStore } from "~/stores/auth";
import type {
  AppNotification,
  NotificationListResponse,
  UnreadCountResponse,
  MarkReadResponse,
} from "~/types/api/notification";

const PER_PAGE = 20;

export const useNotificationStore = defineStore("notification", {
  state: () => ({
    items: [] as AppNotification[],
    unreadCount: 0,
    loading: false,
    page: 1,
    totalPages: 1,
  }),

  getters: {
    hasUnread: (state) => state.unreadCount > 0,
    hasMore: (state) => state.page < state.totalPages,
  },

  actions: {
    // 認証ヘッダー付きで $fetch を行う共通ヘルパー
    async request<T>(url: string, method: "GET" | "PATCH"): Promise<T> {
      const config = useRuntimeConfig();
      const authStore = useAuthStore();
      return await $fetch<T>(url, {
        method,
        baseURL: config.public.apiBaseUrl,
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
      });
    },

    // 通知一覧を最初から取得する
    async fetch() {
      this.loading = true;
      try {
        const response = await this.request<NotificationListResponse>(
          `/api/v1/notifications?page=1&per_page=${PER_PAGE}`,
          "GET",
        );
        this.items = response.notifications;
        this.unreadCount = response.unread_count;
        this.page = response.pagination.current_page;
        this.totalPages = response.pagination.total_pages;
      } finally {
        this.loading = false;
      }
    },

    // 次ページを取得して末尾に追加する
    async fetchMore() {
      if (!this.hasMore || this.loading) return;
      this.loading = true;
      try {
        const nextPage = this.page + 1;
        const response = await this.request<NotificationListResponse>(
          `/api/v1/notifications?page=${nextPage}&per_page=${PER_PAGE}`,
          "GET",
        );
        this.items = [...this.items, ...response.notifications];
        this.unreadCount = response.unread_count;
        this.page = response.pagination.current_page;
        this.totalPages = response.pagination.total_pages;
      } finally {
        this.loading = false;
      }
    },

    // 未読数のみ取得する（ヘッダーのバッジ更新用）
    async fetchUnreadCount() {
      const response = await this.request<UnreadCountResponse>(
        "/api/v1/notifications/unread_count",
        "GET",
      );
      this.unreadCount = response.unread_count;
    },

    // 個別の通知を既読にする
    async markAsRead(id: number) {
      const response = await this.request<MarkReadResponse>(
        `/api/v1/notifications/${id}/read`,
        "PATCH",
      );
      const target = this.items.find((n) => n.id === id);
      if (target) target.read = true;
      this.unreadCount = response.unread_count;
    },

    // すべての通知を既読にする
    async markAllRead() {
      await this.request<UnreadCountResponse>(
        "/api/v1/notifications/read_all",
        "PATCH",
      );
      this.items = this.items.map((n) => ({ ...n, read: true }));
      this.unreadCount = 0;
    },

    // リアルタイム受信時に先頭へ追加する（フェーズ2で使用）
    prepend(notification: AppNotification) {
      this.items = [notification, ...this.items];
      if (!notification.read) this.unreadCount += 1;
    },
  },
});
