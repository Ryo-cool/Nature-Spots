declare module "imagemin-webp" {
  interface Options {
    quality?: number;
    resize?: {
      width?: number;
      height?: number;
    };
  }
  function imageminWebp(options?: Options): any;
  export default imageminWebp;
}
