class MyInject {
  constructor (app) {
    this.app = app
  }

  // 追加
  // i18nページタイトル変換
  pageTitle (routeName) {
    const jsonPath = `pages.${routeName.replace(/-/g, '.')}`
    const title = this.app.i18n.t(jsonPath)
    return (typeof (title) === 'object') ? title.index : title
  }
}

export default ({ app }, inject) => {
  inject('my', new MyInject(app))
}