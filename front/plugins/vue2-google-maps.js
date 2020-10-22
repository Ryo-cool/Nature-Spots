import Vue from 'vue';
import * as VueGoogleMaps from '~/node_modules/vue2-google-maps/src/main';

Vue.use(VueGoogleMaps, {
  load: 
  {
    key: `AIzaSyAPUmpeW10m-A686TfTWSen-EflFYIIFKw`,
    libraries: 'places',
  },
});
