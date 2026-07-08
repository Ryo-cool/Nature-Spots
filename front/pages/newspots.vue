<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" sm="6" class="my-6 text-center" align-self="center">
        <h1 class="mb-4">スポット投稿</h1>
        <div class="text-error">
          {{ alert }}
        </div>
        <v-text-field
          v-model="name"
          label="スポット名(必須)"
          type="text"
          variant="outlined"
          @change="onChange"
        />

        <v-text-field
          v-model="introduction"
          label="説明(必須)"
          type="text"
          variant="outlined"
        />
        <v-img :src="preview" />
        <v-file-input
          chips
          small-chips
          show-size
          label="画像(任意)"
          accept="image/png, image/jpeg, image/bmp"
          prepend-icon="mdi-camera"
          @update:model-value="setImage"
        />
        <v-select
          v-model="selectedPrefectureId"
          label="都道府県(必須)"
          item-title="name"
          item-value="id"
          :items="prefectureOptions"
          variant="outlined"
        />

        <v-text-field
          v-model="address"
          label="住所(必須)"
          type="text"
          variant="outlined"
        />

        <v-select
          v-model="selectedLocationId"
          label="ジャンル(必須)"
          item-title="name"
          item-value="id"
          :items="locationOptions"
          variant="outlined"
        />
        <v-btn color="primary" :loading="loading" @click="createSpot">
          スポットを投稿する
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "~/composables/useApi";
import { useToastStore } from "~/stores/toast";

definePageMeta({
  layout: "loggedIn",
  middleware: "auth",
});

interface ActiveHashItem {
  id: number;
  name: string;
}

interface SpotsIndexResponse {
  spots?: unknown[];
  prefectures?: ActiveHashItem[];
  locations?: ActiveHashItem[];
}

interface GeocoderResult {
  formatted_address: string;
  geometry: {
    location: {
      lat: () => number;
      lng: () => number;
    };
  };
}

interface GeocoderLike {
  geocode: (
    request: { address: string },
    callback: (results: GeocoderResult[] | null, status: string) => void,
  ) => void;
}

interface GoogleMapsWindow {
  google?: {
    maps?: {
      Geocoder: new () => GeocoderLike;
      GeocoderStatus?: { OK: string };
    };
  };
}

const $api = useApi();
const router = useRouter();
const toastStore = useToastStore();
const { $googleMapsKey } = useNuxtApp();

const name = ref("");
const introduction = ref("");
const selectedPrefectureId = ref<number | null>(null);
const address = ref("");
const selectedLocationId = ref<number | null>(null);
const lat = ref<number | null>(null);
const lng = ref<number | null>(null);
const alert = ref("");
const image = ref<File | null>(null);
const preview = ref("");
const loading = ref(false);
const prefectureOptions = ref<ActiveHashItem[]>([]);
const locationOptions = ref<ActiveHashItem[]>([]);
const geocoder = ref<GeocoderLike | null>(null);

const getGoogleMaps = () => {
  return (window as unknown as GoogleMapsWindow).google?.maps;
};

const loadGoogleMapsScript = (): Promise<void> => {
  return new Promise((resolve, reject) => {
    if (getGoogleMaps()?.Geocoder) {
      resolve();
      return;
    }

    const existing = document.querySelector<HTMLScriptElement>(
      'script[data-google-maps="true"]',
    );
    if (existing) {
      existing.addEventListener("load", () => resolve());
      existing.addEventListener("error", () =>
        reject(new Error("Google Maps script failed to load")),
      );
      return;
    }

    const apiKey = typeof $googleMapsKey === "string" ? $googleMapsKey : "";
    if (!apiKey) {
      reject(new Error("Google Maps API key is not configured"));
      return;
    }

    const script = document.createElement("script");
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}`;
    script.async = true;
    script.defer = true;
    script.dataset.googleMaps = "true";
    script.onload = () => resolve();
    script.onerror = () =>
      reject(new Error("Google Maps script failed to load"));
    document.head.appendChild(script);
  });
};

const onChange = () => {
  if (!geocoder.value || !name.value) return;

  geocoder.value.geocode(
    { address: name.value },
    (results: GeocoderResult[] | null, status: string) => {
      const okStatus = getGoogleMaps()?.GeocoderStatus?.OK ?? "OK";
      if (status === okStatus && results?.[0]) {
        alert.value = "";
        lat.value = results[0].geometry.location.lat();
        lng.value = results[0].geometry.location.lng();
        address.value = results[0].formatted_address.replace("日本、", "");
      } else {
        alert.value = "正しいスポットを入力してください";
      }
    },
  );
};

const setImage = (value: File | File[] | null) => {
  const file = Array.isArray(value) ? value[0] : value;
  if (!file) {
    image.value = null;
    preview.value = "";
    return;
  }
  image.value = file;
  preview.value = URL.createObjectURL(file);
};

const createSpot = async () => {
  loading.value = true;
  try {
    const formData = new FormData();
    if (image.value) {
      formData.append("photo", image.value);
    }
    formData.append("name", name.value);
    formData.append("introduction", introduction.value);
    if (selectedPrefectureId.value != null) {
      formData.append("prefecture_id", String(selectedPrefectureId.value));
    }
    if (lat.value != null) {
      formData.append("latitude", String(lat.value));
    }
    if (lng.value != null) {
      formData.append("longitude", String(lng.value));
    }
    formData.append("address", address.value);
    if (selectedLocationId.value != null) {
      formData.append("location_id", String(selectedLocationId.value));
    }

    await $api.post("/api/v1/spots", formData);
    router.push("/");
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "スポットの投稿に失敗しました",
      color: "error",
    });
  } finally {
    loading.value = false;
  }
};

onMounted(async () => {
  try {
    const res = await $api.get<SpotsIndexResponse>("/api/v1/spots");
    prefectureOptions.value = res.data.prefectures || [];
    locationOptions.value = res.data.locations || [];
  } catch (error) {
    console.error(error);
    toastStore.showToast({
      message: "スポット情報の取得に失敗しました",
      color: "error",
    });
  }

  try {
    await loadGoogleMapsScript();
    const maps = getGoogleMaps();
    if (maps?.Geocoder) {
      geocoder.value = new maps.Geocoder();
    }
  } catch (error) {
    console.error(error);
  }
});
</script>
