import { useAuth } from '~/composables/useAuth'
import { useAuthStore } from '~/stores/auth'
import { useToastStore } from '~/stores/toast'

export default defineNuxtRouteMiddleware((to) => {
  const { isAuthenticated } = useAuth()
  const authStore = useAuthStore()
  const toastStore = useToastStore()
  
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
      authStore.logout()
    } else {
      // ログイン前ユーザー
      if (process.client) {
        localStorage.setItem('rememberRoute', JSON.stringify(to.fullPath))
      }
    }
    
    // トースター出力
    toastStore.showToast({ message: msg, color: 'warning' })
    return navigateTo('/login')
  } else if (!authStore.user) {
    // 有効期限内でユーザーが存在しない場合
    authStore.setAuth(false)
    if (process.client) {
      localStorage.removeItem('rememberRoute')
    }
    return navigateTo('/login')
  }
})