import { mount, flushPromises } from "@vue/test-utils";
import { describe, expect, test, vi, beforeEach } from "vitest";
import { ref } from "vue";
import NotificationBell from "../../components/loggedIn/header/NotificationBell.vue";

const mockFetch = vi.fn();
const mockFetchUnreadCount = vi.fn();
const unreadCount = ref(0);
const hasUnread = ref(false);

vi.mock("~/composables/useNotifications", () => ({
  useNotifications: () => ({
    unreadCount,
    hasUnread,
    fetch: mockFetch,
    fetchUnreadCount: mockFetchUnreadCount,
  }),
}));

const globalStubs = {
  "v-menu": {
    template:
      "<div class='v-menu'><slot name='activator' :props='{}' /><slot /></div>",
  },
  "v-btn": { template: "<button class='v-btn'><slot /></button>" },
  "v-badge": {
    props: ["content"],
    template: "<span class='v-badge' :data-content='content'><slot /></span>",
  },
  "v-icon": { template: "<i class='v-icon'><slot /></i>" },
  "v-card": { template: "<div class='v-card'><slot /></div>" },
  "v-card-actions": { template: "<div class='v-card-actions'><slot /></div>" },
  "v-divider": { template: "<hr />" },
  "notification-list": { template: "<div class='notification-list' />" },
};

const mountComponent = () =>
  mount(NotificationBell, {
    global: {
      stubs: globalStubs,
      mocks: { $t: (key: string) => key },
    },
  });

describe("components/loggedIn/header/NotificationBell.vue", () => {
  beforeEach(() => {
    mockFetch.mockReset();
    mockFetchUnreadCount.mockReset();
    unreadCount.value = 0;
    hasUnread.value = false;
  });

  test("マウント時に未読数を取得すること", async () => {
    mountComponent();
    await flushPromises();
    expect(mockFetchUnreadCount).toHaveBeenCalled();
  });

  test("未読がある場合はバッジに件数を表示すること", () => {
    unreadCount.value = 3;
    hasUnread.value = true;
    const wrapper = mountComponent();
    const badge = wrapper.find(".v-badge");
    expect(badge.exists()).toBe(true);
    expect(badge.attributes("data-content")).toBe("3");
  });

  test("未読が100件以上の場合は99+と表示すること", () => {
    unreadCount.value = 150;
    hasUnread.value = true;
    const wrapper = mountComponent();
    expect(wrapper.find(".v-badge").attributes("data-content")).toBe("99+");
  });

  test("未読がない場合はバッジを表示しないこと", () => {
    const wrapper = mountComponent();
    expect(wrapper.find(".v-badge").exists()).toBe(false);
  });
});
