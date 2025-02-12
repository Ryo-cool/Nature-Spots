export * from "./common";
export * from "./spot";
export * from "./auth";

// Vue用の型拡張
declare module "vue" {
  interface Vue {
    $style: { [key: string]: string };
  }
}
