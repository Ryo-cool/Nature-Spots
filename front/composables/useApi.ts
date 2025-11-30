/**
 * $api を安全に取得するcomposable
 * NuxtAppから$apiを取得し、undefinedの場合はエラーをスローします
 */
export const useApi = () => {
  const { $api } = useNuxtApp();

  if (!$api) {
    throw new Error("API client is not available. Make sure the api plugin is loaded.");
  }

  return $api;
};
