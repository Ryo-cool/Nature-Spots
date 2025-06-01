<template>
  <v-col cols="12" md="7" class="hidden-ipad-and-down">
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-img :src="homeImg" :aspect-ratio="1.3" cover>
        <v-container>
          <v-row>
            <v-col
              v-for="prefecture in prefectures"
              :key="prefecture.attributes?.id"
              cols="4"
              sm="2"
              md="3"
              lg="2"
            >
              <nuxt-link
                :to="`prefecture/${prefecture.attributes?.id}`"
                class="text-decoration-none"
              >
                <v-btn color="green-lighten-4">
                  {{ prefecture.attributes?.name }}
                </v-btn>
              </nuxt-link>
            </v-col>
          </v-row>
        </v-container>
      </v-img>
    </v-card>
  </v-col>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import homeImg from "~/assets/images/loggedIn/japanesemap.png";

interface Prefecture {
  attributes: {
    id: number;
    name: string;
  };
}

const { $api } = useNuxtApp();

const prefectures = ref<Prefecture[]>([]);

onMounted(async () => {
  try {
    const res = await $api.get("/api/v1/prefectures");
    prefectures.value = res.data || [];
  } catch (error) {
    console.error("都道府県データの取得に失敗しました:", error);
  }
});
</script>

<style scoped>
.pre {
  padding: 12px 0px 2px 6px;
}
</style>
