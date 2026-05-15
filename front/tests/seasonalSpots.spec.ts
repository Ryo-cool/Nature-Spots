import { mount, flushPromises } from "@vue/test-utils";
import { describe, expect, test, vi, beforeEach } from "vitest";
import SeasonalSpots from "../components/spot/seasonalSpots.vue";

const mockApiGet = vi.fn();

vi.mock("~/composables/useApi", () => ({
  useApi: () => ({
    get: mockApiGet,
  }),
}));

vi.mock("~/composables/useCurrentSeason", () => ({
  useCurrentSeason: () => ({
    getCurrentSeasonKey: () => "spring",
    seasonKeys: ["spring", "summer", "autumn", "winter"],
  }),
}));

const globalStubs = {
  "v-tabs": {
    template: "<div class='v-tabs'><slot /></div>",
  },
  "v-tab": { template: "<button class='v-tab'><slot /></button>" },
  "v-slide-group": {
    template: "<div class='v-slide-group'><slot /></div>",
  },
  "v-slide-group-item": {
    template: "<div class='v-slide-group-item'><slot /></div>",
  },
  "v-card": { template: "<div class='v-card'><slot /></div>" },
  "v-card-text": { template: "<div class='v-card-text'><slot /></div>" },
  "v-img": { template: "<div class='v-img' />" },
  "v-icon": { template: "<i class='v-icon'><slot /></i>" },
  "v-btn": { template: "<button class='v-btn'><slot /></button>" },
  "v-progress-circular": { template: "<div class='v-progress' />" },
};

const mountComponent = () =>
  mount(SeasonalSpots, {
    global: {
      stubs: globalStubs,
      mocks: {
        $t: (key: string) => key,
      },
    },
  });

describe("components/spot/seasonalSpots.vue", () => {
  beforeEach(() => {
    mockApiGet.mockReset();
  });

  test("マウント時に現在の季節でAPIを呼び出すこと", async () => {
    mockApiGet.mockResolvedValueOnce({
      data: {
        spots: [
          {
            id: 1,
            name: "桜スポット",
            seasons: [{ id: 1, key: "spring", name_ja: "春" }],
          },
        ],
        season: { id: 1, key: "spring", name_ja: "春" },
      },
    });

    const wrapper = mountComponent();
    await flushPromises();

    expect(mockApiGet).toHaveBeenCalledWith(
      "/api/v1/spots/seasonal?season=spring",
    );
    expect(wrapper.text()).toContain("桜スポット");
  });

  test("スポットが空の場合は空メッセージを表示すること", async () => {
    mockApiGet.mockResolvedValueOnce({
      data: { spots: [], season: { id: 1, key: "spring", name_ja: "春" } },
    });

    const wrapper = mountComponent();
    await flushPromises();

    expect(wrapper.text()).toContain("spot.seasonal.empty");
  });

  test("APIエラー時はエラーメッセージを表示すること", async () => {
    mockApiGet.mockRejectedValueOnce(new Error("network error"));
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});

    const wrapper = mountComponent();
    await flushPromises();

    expect(wrapper.text()).toContain("spot.seasonal.error");
    expect(errorSpy).toHaveBeenCalled();
    errorSpy.mockRestore();
  });

  test("季節を切り替えるとそのAPIを呼び出すこと", async () => {
    mockApiGet.mockResolvedValue({
      data: { spots: [], season: { id: 2, key: "summer", name_ja: "夏" } },
    });

    const wrapper = mountComponent();
    await flushPromises();
    mockApiGet.mockClear();

    interface Exposed {
      selectedSeason: { value: string };
    }
    const exposed = wrapper.vm.$.exposed as Exposed;
    exposed.selectedSeason.value = "summer";
    await flushPromises();

    expect(mockApiGet).toHaveBeenCalledWith(
      "/api/v1/spots/seasonal?season=summer",
    );
  });
});
