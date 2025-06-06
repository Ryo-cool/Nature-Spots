import { defineStore } from "pinia";

interface ToastMessage {
  message: string;
  color?: string;
  timeout?: number;
}

export const useToastStore = defineStore("toast", {
  state: () => ({
    show: false,
    message: "",
    color: "info",
    timeout: 3000,
  }),

  getters: {
    visible: (state) => state.show,
  },

  actions: {
    showToast({ message, color = "info", timeout = 3000 }: ToastMessage) {
      this.show = true;
      this.message = message;
      this.color = color;
      this.timeout = timeout;

      if (timeout > 0) {
        setTimeout(() => {
          this.clearToast();
        }, timeout);
      }
    },

    clearToast() {
      this.show = false;
      this.message = "";
    },

    hideToast() {
      this.clearToast();
    },
  },
});
