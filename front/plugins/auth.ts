export default defineNuxtPlugin(async (nuxtApp) => {
  // useAuthはcomposableとして利用できるので、プラグインでの初期化のみを行う
  const { initialize } = useAuth()
  
  // クライアントサイドでのみ初期化を実行
  if (process.client) {
    await initialize()
  }
})