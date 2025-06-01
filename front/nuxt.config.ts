// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,
  devtools: { enabled: true },

  app: {
    head: {
      titleTemplate: "%s - Nature Spots",
      title: "Nature Spots",
      meta: [
        { charset: "utf-8" },
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        {
          name: "description",
          content: "Discover beautiful nature spots around you",
        },
      ],
      link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
    },
  },

  css: ["vuetify/lib/styles/main.sass", "~/assets/sass/main.scss"],

  modules: ["@pinia/nuxt", "@nuxtjs/i18n"],

  i18n: {
    strategy: "no_prefix",
    locales: ["ja", "en"],
    defaultLocale: "ja",
    vueI18n: "./i18n.config.ts",
  },

  build: {
    transpile: ["vuetify"],
  },

  runtimeConfig: {
    public: {
      appName: process.env.APP_NAME || "Nature Spots",
      cryptoKey: process.env.CRYPTO_KEY || "default-key",
      googleMapsApiKey: process.env.GOOGLE_MAPS_API_KEY || "",
      apiBaseUrl:
        process.env.NODE_ENV === "production"
          ? "https://www.nature-spots-api.work"
          : "http://localhost:3000",
    },
  },

  typescript: {
    strict: true,
    typeCheck: true,
  },

  imports: {
    dirs: ["stores"],
  },

  components: [{ path: "~/components", pathPrefix: false }],
});
