import { defineStore } from "pinia";
import type { User } from "~/types";

interface AuthResponse {
  token: string;
  exp: number;
  user: User | null;
}

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

    async login(credentials: {
      email: string;
      password: string;
    }): Promise<AuthResponse | null> {
      try {
        const config = useRuntimeConfig();
        const response = await $fetch<AuthResponse>("/api/v1/user_token", {
          method: "POST",
          body: { auth: credentials },
          baseURL: config.public.apiBaseUrl,
          credentials: "include",
        });

        this.setToken(response.token);
        this.setUser(response.user);
        this.setAuth(true);

        if (!response.user) {
          await this.fetchUser();
        }

        return response;
      } catch {
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
          credentials: "include",
        });
      } finally {
        this.setToken(null);
        this.setUser(null);
        this.setAuth(false);
      }
    },

    async fetchUser() {
      try {
        const config = useRuntimeConfig();

        const response = await $fetch<{ user: User }>(
          "/api/v1/users/current_user",
          {
            method: "GET",
            baseURL: config.public.apiBaseUrl,
            headers: {
              Authorization: `Bearer ${this.token}`,
            },
          },
        );

        this.setUser(response.user);
        return response.user;
      } catch {
        return null;
      }
    },
  },
});
