import { defineStore } from "pinia";
import type { User } from "~/types";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null as User | null,
    token: null as string | null,
    isAuthenticated: false,
  }),

  getters: {
    getUser: (state) => state.user,
    getToken: (state) => state.token,
    getIsAuthenticated: (state) => state.isAuthenticated,
  },

  actions: {
    setUser(user: User | null) {
      this.user = user;
    },

    setToken(token: string | null) {
      this.token = token;
    },

    setAuth(isAuth: boolean) {
      this.isAuthenticated = isAuth;
    },

    async login(credentials: { email: string; password: string }) {
      try {
        const config = useRuntimeConfig();
        const response = await $fetch("/api/v1/user_token", {
          method: "POST",
          body: credentials,
          baseURL: config.public.apiBaseUrl,
        });

        this.setToken(response.token);
        this.setAuth(true);
        await this.fetchUser();

        return response.token;
      } catch (error) {
        this.setAuth(false);
        return null;
      }
    },

    async logout() {
      try {
        const config = useRuntimeConfig();
        await $fetch("/api/v1/user_token", {
          method: "DELETE",
          baseURL: config.public.apiBaseUrl,
        });

        this.setToken(null);
        this.setUser(null);
        this.setAuth(false);
      } catch (error) {
        throw error;
      }
    },

    async fetchUser() {
      try {
        const config = useRuntimeConfig();

        const response = await $fetch("/api/v1/users/me", {
          method: "GET",
          baseURL: config.public.apiBaseUrl,
          headers: {
            Authorization: `Bearer ${this.token}`,
          },
        });

        this.setUser(response);
        return response;
      } catch (error) {
        return null;
      }
    },
  },
});
