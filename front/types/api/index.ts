export * from "./auth";
export * from "./spot";
export * from "./common";
export * from "./notification";

// APIのベースURL設定の型
export interface ApiConfig {
  baseURL: string;
  timeout: number;
  headers: {
    "Content-Type": string;
    Accept: string;
    Authorization?: string;
  };
}
