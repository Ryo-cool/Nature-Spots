import { Plugin } from "@nuxt/types"

const serviceWorkerPlugin: Plugin = () => {
  if (process.client && "serviceWorker" in navigator) {
    window.addEventListener("load", () => {
      navigator.serviceWorker
        .register("/sw.js")
        .then((registration) => {
          console.log("Service Worker registered: ", registration)
        })
        .catch((error) => {
          console.error("Service Worker registration failed: ", error)
        })
    })
  }
}

export default serviceWorkerPlugin
