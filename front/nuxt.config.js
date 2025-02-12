import colors from "vuetify/es5/util/colors";

export default {
  ssr: false,
  components: true,
  /*
   ** Headers of the page
   */
  head: {
    titleTemplate: "%s - " + process.env.npm_package_name,
    title: process.env.npm_package_name || "",
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      {
        hid: "description",
        name: "description",
        content: process.env.npm_package_description || "",
      },
    ],
    link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: "#fff" },
  /*
   ** Global CSS
   */
  css: ["~/assets/sass/main.scss"],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    "plugins/auth",
    "plugins/axios",
    "plugins/myInject",
    "plugins/nuxtClientInit",
    { src: "~/plugins/vue2-google-maps.js", ssr: false },
    "~/plugins/image-optimization",
    { src: "~/plugins/service-worker.client", mode: "client" },
  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: ["@nuxtjs/vuetify"],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    "@nuxtjs/axios",
    "nuxt-i18n",
    "nuxt-webfontloader",
  ],
  webfontloader: {
    google: {
      families: ["Noto+Sans+JP:300", "Kosugi+Maru"],
    },
  },
  publicRuntimeConfig: {
    appName: process.env.APP_NAME,
    cryptoKey: process.env.CRYPTO_KEY,
    googleMapsApiKey: process.env.GOOGLE_MAPS_API_KEY,
  },
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  axios: {
    // クロスサイトリクエスト時にCookieを使用することを許可する
    // Doc: https://axios.nuxtjs.org/options/#credentials
    credentials: true,
    baseURL:
      process.env.NODE_ENV === "production"
        ? "https://www.nature-spots-api.work"
        : "http://localhost:3000",
  },
  /*
   ** vuetify module configuration
   ** https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    treeShake: true,
    customVariables: ["~/assets/sass/variables.scss"],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
        light: {
          primary: "4080BE",
          info: "4FC1E9",
          success: "44D69E",
          warning: "FEB65E",
          error: "FB8678",
          background: "f6f6f4",
          myblue: "1867C0",
        },
      },
    },
  },
  i18n: {
    strategy: "no_prefix",
    locales: ["ja", "en"],
    defaultLocale: "ja",
    // Doc: https://kazupon.github.io/vue-i18n/api/#properties
    vueI18n: {
      fallbackLocale: "ja",
      // silentTranslationWarn: true,
      silentFallbackWarn: true,
      messages: {
        ja: require("./locales/ja.json"),
        en: require("./locales/en.json"),
      },
    },
  },
  build: {
    extend(config, ctx) {
      config.externals = config.externals || [];
      if (!ctx.isClient) {
        config.externals.splice(0, 0, function (context, request, callback) {
          if (/^vue2-google-maps($|\/)/.test(request)) {
            callback(null, false);
          } else {
            callback();
          }
        });
      }
    },
    vendor: ["vue2-google-maps"],
  },
};
