interface ImageOptimizationOptions {
  quality?: number;
  maxWidth?: number;
  maxHeight?: number;
}

export default defineNuxtPlugin(() => {
  const resizeImage = async (
    file: File,
    options: ImageOptimizationOptions = {},
  ): Promise<Blob> => {
    return new Promise((resolve, reject) => {
      const img = new Image();
      const canvas = document.createElement("canvas");
      const ctx = canvas.getContext("2d");

      img.onload = () => {
        let { width, height } = img;

        // アスペクト比を保持しながらリサイズ
        if (options.maxWidth && width > options.maxWidth) {
          height = (height * options.maxWidth) / width;
          width = options.maxWidth;
        }
        if (options.maxHeight && height > options.maxHeight) {
          width = (width * options.maxHeight) / height;
          height = options.maxHeight;
        }

        canvas.width = width;
        canvas.height = height;

        if (ctx) {
          ctx.drawImage(img, 0, 0, width, height);
          canvas.toBlob(
            (blob) => {
              if (blob) {
                resolve(blob);
              } else {
                reject(new Error("Failed to create blob"));
              }
            },
            "image/webp",
            options.quality ? options.quality / 100 : 0.8,
          );
        } else {
          reject(new Error("Failed to get canvas context"));
        }
      };

      img.onerror = () => {
        reject(new Error("Failed to load image"));
      };

      img.src = URL.createObjectURL(file);
    });
  };

  const createResponsiveImage = async (
    file: File,
    sizes: { width: number; quality?: number }[],
  ): Promise<{ [key: string]: Blob }> => {
    const results: { [key: string]: Blob } = {};

    for (const size of sizes) {
      const optimized = await resizeImage(file, {
        maxWidth: size.width,
        quality: size.quality || 80,
      });
      results[`${size.width}w`] = optimized;
    }

    return results;
  };

  const checkWebPSupport = (): boolean => {
    if (!process.client) return false;

    const canvas = document.createElement("canvas");
    canvas.width = 1;
    canvas.height = 1;
    return canvas.toDataURL("image/webp").indexOf("data:image/webp") === 0;
  };

  // Nuxt 3形式でプラグインとして関数を提供
  return {
    provide: {
      imageOptimization: {
        convertToWebP: resizeImage,
        createResponsiveImage,
        checkWebPSupport,
      },
    },
  };
});
