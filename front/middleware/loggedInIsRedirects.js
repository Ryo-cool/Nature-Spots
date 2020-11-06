export default ({ $auth, route, redirect }) => {
  // ログイン後ユーザーのリダイレクト処理
  const loggedInUserNotAccess = ['signup', 'login']
  if ($auth.loggedIn && loggedInUserNotAccess.includes(route.name)) {
    return redirect('/')
  }
}