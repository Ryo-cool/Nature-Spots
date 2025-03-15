import { useI18n } from 'vue-i18n'

export default defineNuxtPlugin((nuxtApp) => {
  const { t } = useI18n()
  
  const helpers = {
    // i18nページタイトル変換
    pageTitle(routeName: string): string {
      const jsonPath = `pages.${routeName.replace(/-/g, ".")}`
      const title = t(jsonPath)
      return typeof title === "object" ? title.index : title
    },
    
    format(date: string | Date): string {
      const dateTimeFormat = new Intl.DateTimeFormat("ja", {
        dateStyle: "medium",
        timeStyle: "short",
      })
      return dateTimeFormat.format(new Date(date))
    },
    
    spotLinkTo(id: number | string, name = "spots-id") {
      return { name, params: { id } }
    }
  }
  
  return {
    provide: {
      my: helpers
    }
  }
})