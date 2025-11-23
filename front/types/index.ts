import type { RouteLocationNormalized } from "vue-router";

// User types
export interface User {
  id: number;
  email: string;
  name: string;
  image?: {
    url: string;
  };
}

// Spot types
export interface Spot {
  id: number;
  name: string;
  description: string;
  location: string;
  images: string[];
}

// Auth types
export interface LoginCredentials {
  email: string;
  password: string;
}

export interface SignupCredentials {
  email: string;
  name: string;
  password: string;
  password_confirmation: string;
}

// API response types
export interface ApiResponse<T> {
  data: T;
  status: number;
  message?: string;
}

// Declaration merging for Nuxt
declare module "#app" {
  interface PageMeta {
    layout?: string | ((route: RouteLocationNormalized) => string);
    middleware?: string | string[];
    auth?: boolean;
  }
}

// Declare image module types
declare module "*.png";
declare module "*.jpg";
declare module "*.jpeg";
