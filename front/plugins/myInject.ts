import type { Composer } from "vue-i18n";

export default defineNuxtPlugin((nuxtApp) => {
  const i18n = nuxtApp.$i18n as Composer | undefined;

  const helpers = {
    // i18nページタイトル変換
    pageTitle(routeName: string): string {
      const jsonPath = `pages.${routeName.replace(/-/g, ".")}`;
      const raw = i18n?.t(jsonPath);
      return typeof raw === "string" ? raw : "";
    },

    format(date: string | Date): string {
      const dateTimeFormat = new Intl.DateTimeFormat("ja", {
        dateStyle: "medium",
        timeStyle: "short",
      });
      return dateTimeFormat.format(new Date(date));
    },

    spotLinkTo(id: number | string, name = "spots-id") {
      return { name, params: { id } };
    },
  };

  return {
    provide: {
      my: helpers,
    },
  };
});
