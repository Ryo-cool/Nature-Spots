// https://nuxt.com/docs/api/configuration/nuxt-config
const cryptoKey = process.env.CRYPTO_KEY;
const effectiveCryptoKey = cryptoKey ?? "dev-default-key";

if (!cryptoKey) {
  // 本番環境では必ず環境変数を設定すること
  console.warn(
    "[nuxt.config] CRYPTO_KEY is not set. Falling back to dev-default-key.",
  );
}

export default defineNuxtConfig({
  compatibilityDate: "2025-12-10",
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

  nitro: {
    compressPublicAssets: true,
  },

  experimental: {
    payloadExtraction: false,
  },

  vite: {
    build: {
      rollupOptions: {
        output: {
          manualChunks: {
            vuetify: ["vuetify"],
            "google-maps": ["vue3-google-map"],
            utils: ["date-fns", "crypto-js"],
          },
        },
      },
      chunkSizeWarningLimit: 1000,
    },
    optimizeDeps: {
      include: ["vue3-google-map", "date-fns", "crypto-js"],
    },
  },

  runtimeConfig: {
    public: {
      appName: process.env.APP_NAME || "Nature Spots",
      cryptoKey: effectiveCryptoKey,
      guestEmail: process.env.GUEST_EMAIL,
      guestPassword: process.env.GUEST_PASSWORD,
      googleMapsApiKey: process.env.GOOGLE_MAPS_API_KEY || "",
      apiBaseUrl:
        process.env.NODE_ENV === "production"
          ? "https://www.nature-spots-api.work"
          : "http://localhost:3001",
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
