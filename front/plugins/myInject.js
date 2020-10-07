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
  
  format (date) {
    const dateTimeFormat = new Intl.DateTimeFormat(
      'ja', { dateStyle: 'medium', timeStyle: 'short' }
    )
    return dateTimeFormat.format(new Date(date))
  }

  spotLinkTo (id, name = 'spots-id') {
    return { name, params: { id } }
  }

}

export default ({ app }, inject) => {
  inject('my', new MyInject(app))
}