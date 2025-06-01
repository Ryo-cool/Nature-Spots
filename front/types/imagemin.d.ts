declare module "imagemin" {
  interface Options {
    plugins: any[];
  }

  function imagemin(
    input: Buffer | string[],
    options?: Options,
  ): Promise<
    {
      data: Buffer;
      path?: string;
      sourceData?: Buffer;
      destinationPath?: string;
    }[]
  >;

  namespace imagemin {
    function buffer(input: Uint8Array, options?: Options): Promise<Buffer>;
  }

  export = imagemin;
}

declare module "imagemin-webp" {
  interface Options {
    quality?: number;
    lossless?: boolean;
    nearLossless?: boolean;
    alphaQuality?: number;
    reductionEffort?: number;
    metadata?: string[];
    preset?: string;
    method?: number;
    sns?: number;
    filter?: number;
    autoFilter?: boolean;
    sharpness?: number;
    resize?: {
      width?: number;
      height?: number;
    };
    crop?: {
      x: number;
      y: number;
      width: number;
      height: number;
    };
  }

  function imageminWebp(options?: Options): any;
  export = imageminWebp;
}
