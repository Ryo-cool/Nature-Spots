import { createVuetify } from "vuetify";
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import "vuetify/styles";

export default defineNuxtPlugin((nuxtApp: any) => {
  const vuetify = createVuetify({
    components,
    directives,
    theme: {
      defaultTheme: "light",
      themes: {
        light: {
          dark: false,
          colors: {
            primary: "#4080BE",
            info: "#4FC1E9",
            success: "#44D69E",
            warning: "#FEB65E",
            error: "#FB8678",
            background: "#f6f6f4",
            myblue: "#1867C0",
          },
        },
        dark: {
          dark: true,
          colors: {
            primary: "#2196F3",
            accent: "#757575",
            secondary: "#FFC107",
            info: "#00BCD4",
            warning: "#FF9800",
            error: "#FF5252",
            success: "#4CAF50",
          },
        },
      },
    },
  });

  nuxtApp.vueApp.use(vuetify);
});
