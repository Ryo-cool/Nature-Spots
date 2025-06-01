export default defineNuxtPlugin((_nuxtApp: any) => {
  const config = useRuntimeConfig();

  // Vue 3向けにGoogle Maps設定をグローバルに提供
  return {
    provide: {
      googleMapsKey: config.public.googleMapsApiKey,
    },
  };
});
