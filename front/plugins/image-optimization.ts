import imagemin from "imagemin";
import imageminWebp from "imagemin-webp";

interface ImageOptimizationOptions {
  quality?: number;
  resize?: {
    width?: number;
    height?: number;
  };
}

export default defineNuxtPlugin((nuxtApp) => {
  const convertToWebP = async (
    file: File | Blob,
    options: ImageOptimizationOptions = {}
  ): Promise<Blob> => {
    const buffer = await file.arrayBuffer();
    const optimizedBuffer = await imagemin.buffer(new Uint8Array(buffer), {
      plugins: [
        imageminWebp({
          quality: options.quality || 80,
          resize: options.resize,
        }),
      ],
    });
    return new Blob([optimizedBuffer], { type: "image/webp" });
  };

  const createResponsiveImage = async (
    file: File,
    sizes: { width: number; quality?: number }[]
  ): Promise<{ [key: string]: Blob }> => {
    const results: { [key: string]: Blob } = {};

    for (const size of sizes) {
      const optimized = await convertToWebP(file, {
        quality: size.quality || 80,
        resize: { width: size.width },
      });
      results[`${size.width}w`] = optimized;
    }

    return results;
  };

  const checkWebPSupport = (): boolean => {
    if (!process.client) return false;
    
    const canvas = document.createElement("canvas");
    return canvas.toDataURL("image/webp").indexOf("data:image/webp") === 0;
  };

  // Nuxt 3形式でプラグインとして関数を提供
  return {
    provide: {
      imageOptimization: {
        convertToWebP,
        createResponsiveImage,
        checkWebPSupport,
      }
    }
  };
});