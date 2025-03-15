export default defineNuxtPlugin((nuxtApp) => {
  const config = useRuntimeConfig();
  
  // Vue 3向けにGoogle Maps設定をグローバルに提供
  nuxtApp.provide('googleMapsKey', config.public.googleMapsApiKey);
  
  // ライブラリの利用は各コンポーネントで行う
  // Vue3では、vue3-google-mapをコンポーネントレベルで使用する
});