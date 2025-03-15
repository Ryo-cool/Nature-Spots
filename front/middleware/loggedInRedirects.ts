import { useAuth } from '~/composables/useAuth'
import { navigateTo } from '#app'

export default defineNuxtRouteMiddleware((to) => {
  const { loggedIn } = useAuth()
  
  // ログイン済みの場合はメインページにリダイレクト
  if (loggedIn.value) {
    return navigateTo('/')
  }
})