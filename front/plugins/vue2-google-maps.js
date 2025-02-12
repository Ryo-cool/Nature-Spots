import Vue from "vue";
import * as VueGoogleMaps from "~/node_modules/vue2-google-maps/src/main";

export default ({ $config }) => {
  Vue.use(VueGoogleMaps, {
    load: {
      key: $config.googleMapsApiKey,
      libraries: "places",
    },
  });
};
