import { setActivePinia, createPinia } from "pinia";
import { describe, expect, test, vi, beforeEach } from "vitest";
import { useNotificationStore } from "../../stores/notification";
import type { AppNotification } from "../../types/api/notification";

const mockFetch = vi.fn();

const buildNotification = (
  overrides: Partial<AppNotification> = {},
): AppNotification => ({
  id: 1,
  action: "followed",
  read: false,
  created_at: "2026-05-28T00:00:00Z",
  actor: { id: 2, email: "a@example.com", name: "Taro" },
  notifiable: { type: "relationship", user_id: 2 },
  ...overrides,
});

describe("stores/notification", () => {
  beforeEach(() => {
    setActivePinia(createPinia());
    mockFetch.mockReset();
    vi.stubGlobal("$fetch", mockFetch);
  });

  test("fetch() で一覧・未読数・ページ情報を取得すること", async () => {
    mockFetch.mockResolvedValueOnce({
      notifications: [buildNotification()],
      unread_count: 1,
      pagination: {
        current_page: 1,
        per_page: 20,
        total_pages: 2,
        total_count: 25,
      },
    });

    const store = useNotificationStore();
    await store.fetch();

    expect(store.items).toHaveLength(1);
    expect(store.unreadCount).toBe(1);
    expect(store.totalPages).toBe(2);
    expect(store.hasMore).toBe(true);
    expect(store.hasUnread).toBe(true);
  });

  test("markAsRead() で対象を既読にし未読数を更新すること", async () => {
    const store = useNotificationStore();
    store.items = [buildNotification({ id: 5, read: false })];
    store.unreadCount = 1;

    mockFetch.mockResolvedValueOnce({
      notification: buildNotification({ id: 5, read: true }),
      unread_count: 0,
    });

    await store.markAsRead(5);

    expect(store.items[0].read).toBe(true);
    expect(store.unreadCount).toBe(0);
  });

  test("markAllRead() で全件を既読にすること", async () => {
    const store = useNotificationStore();
    store.items = [
      buildNotification({ id: 1, read: false }),
      buildNotification({ id: 2, read: false }),
    ];
    store.unreadCount = 2;

    mockFetch.mockResolvedValueOnce({ unread_count: 0 });

    await store.markAllRead();

    expect(store.items.every((n) => n.read)).toBe(true);
    expect(store.unreadCount).toBe(0);
  });

  test("prepend() で先頭に追加し未読数を増やすこと", () => {
    const store = useNotificationStore();
    store.items = [buildNotification({ id: 1 })];
    store.unreadCount = 0;

    store.prepend(buildNotification({ id: 99, read: false }));

    expect(store.items[0].id).toBe(99);
    expect(store.unreadCount).toBe(1);
  });
});
