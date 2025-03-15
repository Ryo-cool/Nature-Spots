// User types
export interface User {
  id: number;
  email: string;
  name: string;
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

// declare modules for TypeScript 
declare module '#app' {
  interface PageMeta {
    layout?: string | ((route: any) => string)
    middleware?: string | string[]
    auth?: boolean
  }
}

// Ensure TS doesn't complain about .png imports
declare module '*.png' {
  const value: any
  export default value
}

declare module '*.jpg' {
  const value: any
  export default value
}

declare module '*.jpeg' {
  const value: any
  export default value
}

export {}