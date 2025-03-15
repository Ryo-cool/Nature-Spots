export default defineNuxtPlugin(async () => {
  // useAuthはcomposableとして利用できるので、プラグインでの初期化のみを行う
  const { initialize } = useAuth()
  
  // クライアントサイドでのみ初期化を実行
  if (process.client) {
    try {
      await initialize()
    } catch (error) {
      console.error('Auth initialization error:', error)
    }
  }
})