import axios from "axios"

export default ({ $axios, isDev }) => {
  // baseURL: "https://www.nature-spots.work"
  // リクエストログ
  $axios.onRequest((config) => {
    // if (isDev) 追加
    if (isDev) { console.log(config) }
  })
  // レスポンスログ
  $axios.onResponse((config) => {
    // if (isDev) 追加
    if (isDev) { console.log(config) }
  })
  // エラーログ
  $axios.onError((e) => {
		console.log(e.response)
  })
}