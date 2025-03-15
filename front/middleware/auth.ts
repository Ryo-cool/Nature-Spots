export default defineNuxtRouteMiddleware((to, from) => {
  const { loggedIn, isAuthenticated, logout } = useAuth()
  const authStore = useAuthStore()
  const toastStore = useToastStore()
  const router = useRouter()
  
  // トップページかつユーザーが存在しない場合、何もしない(layouts/welcome.vue表示のため)
  if (to.name === 'index' && !authStore.user) {
    return
  }
  
  // トップページでユーザーが存在する場合はここを通過する
  if (!isAuthenticated()) {
    // 有効期限外の時
    let msg = "ログインが必要です"
    
    if (authStore.user) {
      // ログイン中のユーザー
      msg = "もう一度ログインしてください"
      logout()
    } else {
      // ログイン前ユーザー
      localStorage.setItem('rememberRoute', JSON.stringify(to.fullPath))
    }
    
    // トースター出力
    toastStore.showToast({ message: msg, color: 'warning' })
    return navigateTo('/login')
  } else if (!authStore.user) {
    // 有効期限内でユーザーが存在しない場合
    authStore.setAuth(false)
    localStorage.removeItem('rememberRoute')
    return navigateTo('/login')
  }
})