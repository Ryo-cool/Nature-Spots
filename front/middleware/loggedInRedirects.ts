import { useAuth } from "~/composables/useAuth";

export default defineNuxtRouteMiddleware(() => {
  const { loggedIn } = useAuth();

  // ログイン済みの場合はメインページにリダイレクト
  if (loggedIn.value) {
    return navigateTo("/");
  }
});
